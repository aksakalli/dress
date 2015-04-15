//
//  Subview.m
//  Shades
//
//  Created by yücel uzun on 15/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import "Subview.h"
#import "HSVColorPicker.h"
#import "ServiceInvoker.h"

@interface Subview () <HSVColorPickerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, strong) HSVColorPicker * colorPicker;

@property (nonatomic, strong) NSArray * products;
@property (nonatomic, strong) NSMutableArray * productImages;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIButton * middleButton;

@property (nonatomic) ViewType type;

@property (nonatomic) BOOL pickerInView;

@end

@implementation Subview

- (instancetype) initWithFrame:(CGRect)frame type:(ViewType)type selectedColor:(UIColor *)color delegate: (id <SubviewDelegate>) delegate
{
    if (self = [super initWithFrame: frame])
    {
        _delegate = delegate;
        _type = type;
        if (color == nil) {
            [self showPicker];
        } else{
            _color = color;
            [self showProducts];
        }
        
        UIButton * checkButton = [self createCheckButton];
        [self addSubview: checkButton];
        
        UIButton * closeButton = [self createCloseButton];
        [self addSubview: closeButton];
    }
    return self;
}

- (void) showPicker
{
    [self hideScrollView];
    _pickerInView = YES;
    _colorPicker = [[HSVColorPicker alloc] initWithFrame: self.bounds];
    if (!_color) _color = [UIColor blackColor];
    _colorPicker.color = _color;
    _colorPicker.delegate = self;
    [self insertSubview: _colorPicker atIndex: 0];

    [_middleButton removeFromSuperview];
    _middleButton = [self createCameraButton];
    [self addSubview: _middleButton];
}

- (UIButton *) createCheckButton
{
    UIButton * checkButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage * yesButtonImg = [UIImage imageNamed: @"yes"];
    [checkButton setImage: yesButtonImg forState: UIControlStateNormal];
    [checkButton addTarget: self action: @selector(okButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    CGRect frame = checkButton.frame;
    frame.size = yesButtonImg.size;
    frame.origin.y = self.frame.size.height - frame.size.height - 5;
    frame.origin.x = self.frame.size.width - frame.size.width - 5;
    checkButton.frame = frame;
    
    return checkButton;
}

- (UIButton *) createCloseButton
{
    UIButton * closeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage * closeButtonImg = [UIImage imageNamed: @"close"];
    [closeButton setImage: closeButtonImg forState: UIControlStateNormal];
    [closeButton addTarget: self action: @selector(closeButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    CGRect frame = closeButton.frame;
    frame.size = closeButtonImg.size;
    frame.origin.y = self.frame.size.height - frame.size.height - 5;
    frame.origin.x = 5;
    closeButton.frame = frame;
    
    return closeButton;
}

- (UIButton *) createEditButton
{
    UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage * editButtonImg = [UIImage imageNamed: @"edit"];
    [editButton setImage: editButtonImg forState: UIControlStateNormal];
    [editButton addTarget: self action: @selector(editButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    CGRect frame = editButton.frame;
    frame.size = editButtonImg.size;
    frame.origin.y = self.frame.size.height - frame.size.height - 5;
    frame.origin.x = self.frame.size.width / 2 - frame.size.width / 2;
    editButton.frame = frame;
    
    return editButton;
}

- (UIButton *) createCameraButton
{
    UIButton * cameraButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage * cameraButtonImg = [UIImage imageNamed: @"camera"];
    [cameraButton setImage: cameraButtonImg forState: UIControlStateNormal];
    [cameraButton addTarget: self action: @selector(cameraButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    CGRect frame = cameraButton.frame;
    frame.size = cameraButtonImg.size;
    frame.origin.y = self.frame.size.height - frame.size.height - 5;
    frame.origin.x = self.frame.size.width / 2 - frame.size.width / 2;
    cameraButton.frame = frame;
    
    return cameraButton;
}

- (void) cameraButtonPressed
{
    [self.delegate cameraButtonPressed];
}

- (void)colorPicker:(HSVColorPicker*)colorPicker changedColor:(UIColor*)color
{
    _color = color;
    [self.delegate colorChanged: color];
}

- (void) editButtonPressed
{
    [self hideScrollView];
    [self showPicker];
}

- (void) okButtonPressed
{
    if (_pickerInView)
    {
        [self hidePicker];
    } else
    {
        [self.delegate userSelectedDress: ((UIImageView *)_productImages[_pageControl.currentPage]).image color: _color];
    }
}

- (void) hidePicker
{
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect frame = _colorPicker.frame;
        frame.origin.y = self.frame.size.height;
        _colorPicker.frame = frame;
    } completion:^(BOOL finished) {
        _pickerInView = NO;
        [_colorPicker removeFromSuperview];
        [self showProducts];
    }];
}

- (void) showProducts
{
    [self.delegate showHud];
    [_middleButton removeFromSuperview];
    _middleButton = [self createEditButton];
    [self addSubview: _middleButton];
    
    [[ServiceInvoker serviceInvoker] getURL: [self url] responseBlock:^(id response, NSError * error) {
        [self.delegate hideHud];
        _products = (NSArray *) response;
        [self createScrollView];
    } fromViewController: (UIViewController *) self.delegate];
}



- (NSString *) url
{
    NSString * category;
    if ([self.delegate isMale]) {
        category = _type == ViewTypeDress ? @"mens-clothing-casual-shirts" : (_type == ViewTypeShoe ? @"mens-clothing-chinos" : @"mens-shoes-sporty-lace-ups");
    } else {
        category = _type == ViewTypeDress ? @"womens-clothing-dresses" : (_type == ViewTypeShoe ? @"womens-shoes-high-heels" : @"purses");
    }
    CGFloat redF, greenF, blueF, alpha;
    [_color getRed: &redF green: &greenF blue: &blueF alpha: &alpha];
    NSUInteger red    = redF *255;
    NSUInteger  green  = greenF * 255;
    NSUInteger  blue   = blueF * 255;
    return [NSString stringWithFormat: @"http://5.101.97.25:3000/categories/%@/%li,%li,%li", category, red,green,blue];
}

- (void) closeButtonPressed
{
    [self.delegate subviewCanceled];
}

- (void) hideScrollView
{
    [UIView animateWithDuration: 0.3 animations:^{
        CGRect frame = _scrollView.frame;
        frame.origin.y = self.frame.size.height;
        _scrollView.frame = frame;
        
        frame = _pageControl.frame;
        frame.origin.y = self.frame.size.height;
        _pageControl.frame = frame;
        
        _scrollView.alpha = 0;
        _pageControl.alpha = 0;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        [_pageControl removeFromSuperview];
        _scrollView = nil;
        _pageControl = nil;
    }];
}

- (void) createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 50, self.frame.size.width, 320)];
    [_scrollView setContentSize: CGSizeMake( self.frame.size.width * 10, 320)];
    _scrollView.delegate = self;
    [self addImagesToScrollView];
    [self addLabelsToScrollView];
    [_scrollView setPagingEnabled: YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, 375, self.frame.size.width, 30)];
    _pageControl.numberOfPages = 10;
    _pageControl.currentPage = 0;

    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview: _pageControl];
    [self addSubview: _scrollView];
}

- (void) addImagesToScrollView
{
    _productImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView addSubview: imageView];
        [_productImages addObject: imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSDictionary * product = _products [i];
        [[ServiceInvoker serviceInvoker] getURL: product[@"image"][@"mediumHdUrl"] responseBlock:^(id imageData,NSError * error) {
            NSLog(@"%@", product[@"image"][@"mediumHdUrl"]);
            UIImage * image = [UIImage imageWithData: imageData];
            [imageView setImage: image];
        } fromViewController: (UIViewController *) self.delegate];
    }
}

- (void) addLabelsToScrollView
{
    for (NSUInteger i = 0; i < 10; i++)
    {
        NSDictionary * product = _products [i];
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake (self.scrollView.frame.size.width * i + 10, 0, self.scrollView.frame.size.width, 30)];
        label.text = product[@"price"] ;
        [_scrollView addSubview: label];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    _colorPicker.color = color;
}

@end
