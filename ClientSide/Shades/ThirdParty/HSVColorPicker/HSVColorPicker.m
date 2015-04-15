//
//  ColorPicker.m
//  StreetSoccer
//
//  Created by Alex Klein on 6/21/13.
//  Copyright (c) 2013 Athenstean.com. All rights reserved.
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "HSVColorPicker.h"

// This defines the thickness of the hue circle.
static float const CIRCLE_THICKNESS = 0.2f;
// This defines the size of the saturation/brightness box.
static float const BOX_THICKNESS = 0.7f;


@interface HueCircleLayer : CALayer
{
    unsigned int subDivisions;
}

@property (assign) unsigned int subDivisions;
@end

@implementation HueCircleLayer
@synthesize subDivisions;

- (void)drawInContext:(CGContextRef)context
{
    // First, draw the Hue gradient circle. This is based on
    // http://stackoverflow.com/questions/11783114/draw-outer-half-circle-with-gradient-using-core-graphics-in-ios
    // but with a few bug fixes and changes.
    float const radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f;
    float const thickness = radius * CIRCLE_THICKNESS;
    
    // Bugfix: Opposed to the original code, we draw proper curved pieces and calculate the correct
    // circle position. The original code calculated an incorrect offset that caused gaps between the
    // segments.
    float const sliceAngle = 2.0f * M_PI / self.subDivisions;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, cos(-sliceAngle /2.0f) * (radius - thickness), sin(-sliceAngle/2.0f) * (radius - thickness));
    CGPathAddArc(path, NULL, 0.0f, 0.0f, radius - thickness, -sliceAngle/2.0f, sliceAngle/2.0f + 1.0e-2f, false);
    CGPathAddArc(path, NULL, 0.0f, 0.0f, radius, sliceAngle/2.0f + 1.0e-2f, -sliceAngle/2.0f, true);
    CGPathCloseSubpath(path);
    
    // Move origin to center of control so we can rotate around it to draw our
    // circle.
    CGContextTranslateCTM(context, self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    
    float const incrementAngle = 2.0f * M_PI / (float)self.subDivisions;
    for ( int i = 0; i < self.subDivisions; ++i)
    {
        UIColor * color = [UIColor colorWithHue:(float)i/(float)self.subDivisions saturation:1 brightness:1 alpha:1];
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
        CGContextRotateCTM(context, -incrementAngle);
    }
    CGPathRelease(path);
}

@end

@interface SaturationBrightnessLayer : CAEAGLLayer
{
    CGFloat hue;
    EAGLContext * glContext;
    GLuint framebuffer;
    GLuint renderbuffer;
    GLuint program;
    
    // attribute index
    enum {
        ATTRIB_VERTEX,
        ATTRIB_COLOR,
        NUM_ATTRIBUTES
    };
}

@property (assign) CGFloat hue;

@end

@implementation SaturationBrightnessLayer

-(id)initWithContext:(EAGLContext *) context
{
    self = [super init];
    if (self)
    {
        self.opaque = YES;
        glContext = context;
        [EAGLContext setCurrentContext:glContext];
        glGenRenderbuffers(1, &renderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
        [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
        
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
        
        [self loadShaders];
    }
    return self;
}

- (void)dealloc
{
    if (framebuffer)
    {
        glDeleteFramebuffers(1, &framebuffer);
        framebuffer = 0;
    }
	
    if (renderbuffer)
    {
        glDeleteRenderbuffers(1, &renderbuffer);
        renderbuffer = 0;
    }
	
    // realease the shader program object
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
	
    // tear down context
    if ([EAGLContext currentContext] == glContext)
        [EAGLContext setCurrentContext:nil];
	
    glContext = nil;
}

- (void)layoutSublayers
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
}

- (void)loadShaders
{
    // create shader program
    program = glCreateProgram();
    
    const GLchar * vertexProgram = "precision highp float; \n\
        \n\
        attribute vec4 position; \n\
        varying vec2 uv; \n\
        \n\
        void main() \n\
        { \n\
            gl_Position = vec4(2.0 * position.x - 1.0, 2.0 * position.y - 1.0, 0.0, 1.0); \n\
            uv = position.xy; \n\
        }";
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexProgram, NULL);
    glCompileShader(vertexShader);
    glAttachShader(program, vertexShader);

    // https://gist.github.com/eieio/4109795
    const GLchar * fragmentProgram = "precision highp float; \n\
    varying vec2 uv; \n\
    uniform float hue; \n\
    vec3 hsb_to_rgb(float h, float s, float l) \n\
    { \n\
        float c = l * s; \n\
        h = mod((h * 6.0), 6.0); \n\
        float x = c * (1.0 - abs(mod(h, 2.0) - 1.0)); \n\
        vec3 result; \n\
         \n\
        if (0.0 <= h && h < 1.0) { \n\
            result = vec3(c, x, 0.0); \n\
        } else if (1.0 <= h && h < 2.0) { \n\
            result = vec3(x, c, 0.0); \n\
        } else if (2.0 <= h && h < 3.0) { \n\
            result = vec3(0.0, c, x); \n\
        } else if (3.0 <= h && h < 4.0) { \n\
            result = vec3(0.0, x, c); \n\
        } else if (4.0 <= h && h < 5.0) { \n\
            result = vec3(x, 0.0, c); \n\
        } else if (5.0 <= h && h < 6.0) { \n\
            result = vec3(c, 0.0, x); \n\
        } else { \n\
            result = vec3(0.0, 0.0, 0.0); \n\
        } \n\
     \n\
    result.rgb += l - c; \n\
     \n\
    return result; \n\
    } \n\
     \n\
    void main() \n\
    { \
        gl_FragColor = vec4(hsb_to_rgb(hue, uv.x, uv.y), 1.0); \
    }";

    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentProgram, NULL);
    glCompileShader(fragmentShader);
    glAttachShader(program, fragmentShader);
    
    // bind attribute locations
    // this needs to be done prior to linking
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    
    glLinkProgram(program);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

- (void)setHue:(CGFloat)value
{
    hue = value;
    [self setNeedsDisplay];
}

- (CGFloat)hue
{
    return hue;
}

- (void)display
{
    // Draw a frame
    [EAGLContext setCurrentContext:glContext];
    const GLfloat squareVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    // use shader program
    glUseProgram(program);

    glUniform1f(glGetUniformLocation(program, "hue"), hue);
    
    // update attribute values
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
	
    // draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end

@interface MarkerLayer : CALayer
@end

@implementation MarkerLayer

- (void)drawInContext:(CGContextRef)context
{
    float const thickness = 3.0f;
    CGContextSetLineWidth(context, thickness);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectInset(self.bounds, thickness, thickness));
    CGContextStrokePath(context);
}

@end

@implementation HSVColorPicker
@synthesize subDivisions, delegate;

+ (EAGLContext *)sharedEAGLContext {
    static EAGLContext * sharedEAGLContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    });
    return sharedEAGLContext;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.color = [UIColor whiteColor];
        
        layerHueCircle = [[HueCircleLayer alloc] init];
        layerHueCircle.frame = self.bounds;
        [layerHueCircle setNeedsDisplay];
        [self.layer addSublayer:layerHueCircle];
        
        layerSaturationBrightnessBox = [[SaturationBrightnessLayer alloc] initWithContext:[HSVColorPicker sharedEAGLContext]];
        layerSaturationBrightnessBox.frame = self.bounds;
        [layerSaturationBrightnessBox setNeedsDisplay];
        [self.layer addSublayer:layerSaturationBrightnessBox];
        
        layerHueMarker = [[MarkerLayer alloc] init];
        [layerHueMarker setNeedsDisplay];
        [self.layer addSublayer:layerHueMarker];

        layerSaturationBrightnessMarker = [[MarkerLayer alloc] init];
        [layerSaturationBrightnessMarker setNeedsDisplay];
        [self.layer addSublayer:layerSaturationBrightnessMarker];
        
        hueGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragHue:)];
        hueGestureRecognizer.allowableMovement = FLT_MAX;
        hueGestureRecognizer.minimumPressDuration = 0.0f;
        hueGestureRecognizer.delegate = self;
        [self addGestureRecognizer:hueGestureRecognizer];
        saturationBrightnessGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragSaturationBrightness:)];
        saturationBrightnessGestureRecognizer.allowableMovement = FLT_MAX;
        saturationBrightnessGestureRecognizer.minimumPressDuration = 0.0;
        saturationBrightnessGestureRecognizer.delegate = self;
        [self addGestureRecognizer:saturationBrightnessGestureRecognizer];
        
        self.subDivisions = 256;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float const resolution = MIN(self.bounds.size.width, self.bounds.size.height);
    
    radius = resolution / 2.0f;
    thickness = CIRCLE_THICKNESS * radius;
    boxSize = sqrt(BOX_THICKNESS * radius * BOX_THICKNESS * radius / 2.0f) * 2.0f;
    center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);

    layerHueCircle.frame = self.bounds;
    layerSaturationBrightnessBox.frame = CGRectMake((self.bounds.size.width - boxSize) / 2.0f, (self.bounds.size.height - boxSize) / 2.0f, boxSize, boxSize);
    layerHueMarker.frame = [self hueMarkerRect];
    layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
}

#pragma mark - Properties

- (void)setColor:(UIColor *)aColor
{
    colorHue = 1.0f;
    colorSaturation = 1.0f;
    colorBrightness = 1.0f;
    colorAlpha = 1.0f;
    if ( [aColor getHue:&colorHue saturation:&colorSaturation brightness:&colorBrightness alpha:&colorAlpha] == NO )
    {
        colorHue = 0.0;
        colorSaturation = 0.0f;
        [aColor getWhite:&colorBrightness alpha:&colorAlpha];
    }
        
    layerSaturationBrightnessBox.hue = colorHue;
    layerHueMarker.frame = [self hueMarkerRect];
    layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
}

- (UIColor*)color
{
    return [UIColor colorWithHue:colorHue saturation:colorSaturation brightness:colorBrightness alpha:colorAlpha];
}

- (void)setSubDivisions:(unsigned int)value
{
    subDivisions = value;
    layerHueCircle.subDivisions = value;
}

- (unsigned int)subDivisions
{
    return subDivisions;
}

#pragma mark - Marker positioning

- (CGRect)hueMarkerRect
{
    CGFloat const radians = colorHue * 2.0f * M_PI;
    CGPoint const position = CGPointMake(cos(radians) * (radius - thickness / 2.0f), -sin(radians) * (radius - thickness / 2.0f));
    return CGRectMake(position.x - thickness / 2.0f + self.bounds.size.width / 2.0f, position.y - thickness / 2.0f+ self.bounds.size.height / 2.0f, thickness, thickness);
}

- (CGRect)saturationBrightnessMarkerRect
{
    return CGRectMake(colorSaturation * boxSize - boxSize / 2.0f - thickness / 2.0f + self.bounds.size.width / 2.0f, (1.0f - colorBrightness) * boxSize - boxSize / 2.0f - thickness / 2.0f + self.bounds.size.height / 2.0f, thickness, thickness);
}

#pragma mark - Touch handling

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == hueGestureRecognizer )
    {
        // Check if the touch started inside the circle.
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const distanceSquared = (center.x - position.x) * (center.x - position.x) + (center.y - position.y) * (center.y - position.y);
        return ( (radius - thickness) * (radius - thickness) < distanceSquared ) && ( distanceSquared <= radius * radius );
    }
    else if ( gestureRecognizer == saturationBrightnessGestureRecognizer )
    {
        // Check if the touch started inside the circle.
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const saturation = (position.x - center.x) / boxSize + 0.5f;
        CGFloat const brightness = (position.y - center.y) / boxSize + 0.5f;
        
        return (saturation > -0.1) && (saturation < 1.1) && (brightness > -0.1) && (brightness < 1.1);
    }
    return YES;
}

- (void)handleDragHue:(UIGestureRecognizer *)gestureRecognizer
{
    if ( (gestureRecognizer.state == UIGestureRecognizerStateBegan) || (gestureRecognizer.state == UIGestureRecognizerStateChanged) )
    {
        CGPoint const position = [gestureRecognizer locationInView:self];
        CGFloat const distanceSquared = (center.x - position.x) * (center.x - position.x) + (center.y - position.y) * (center.y - position.y);
        if ( distanceSquared < 1.0e-3f )
        {
            return;
        }

        CGFloat const radians = atan2(center.y - position.y, position.x - center.x);
        colorHue = radians / (2.0f * M_PI);
        if ( colorHue < 0.0f )
        {
            colorHue += 1.0f;
        }
        layerSaturationBrightnessBox.hue = colorHue;
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        layerHueMarker.frame = [self hueMarkerRect];
        [CATransaction commit];
        
        if ( [delegate respondsToSelector:@selector(colorPicker:changedColor:)] )
        {
            [delegate colorPicker:self changedColor:self.color];
        }
    }
}

- (void)handleDragSaturationBrightness:(UIGestureRecognizer *)gestureRecognizer
{
    if ( (gestureRecognizer.state == UIGestureRecognizerStateBegan) || (gestureRecognizer.state == UIGestureRecognizerStateChanged) )
    {
        // Check if the touch started inside the circle.
        CGPoint const position = [gestureRecognizer locationInView:self];
        colorSaturation = MAX(0.0f, MIN(1.0f, (position.x - center.x) / boxSize + 0.5f));
        colorBrightness = MAX(0.0f, MIN(1.0f, (center.y - position.y) / boxSize + 0.5f));
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        layerSaturationBrightnessMarker.frame = [self saturationBrightnessMarkerRect];
        [CATransaction commit];
        
        if ( [delegate respondsToSelector:@selector(colorPicker:changedColor:)] )
        {
            [delegate colorPicker:self changedColor:self.color];
        }
    }
}

@end
