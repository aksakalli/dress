//
//  MainViewController.m
//  Shades
//
//  Created by yücel uzun on 15/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import "MainViewController.h"
#import "Subview.h"
#import "MBProgressHUD.h"
#import "CCColorCube.h"

@interface MainViewController () <SubviewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton * dressButton;
@property (weak, nonatomic) IBOutlet UIButton * bagButton;
@property (weak, nonatomic) IBOutlet UIButton * shoeButton;

@property (nonatomic, strong) UIColor * color1;
@property (nonatomic, strong) UIColor * color2;
@property (nonatomic, strong) UIColor * color3;

@property (nonatomic, strong) UIColor * currentColor;

@property (nonatomic) CGFloat originalOriginX;
@property (nonatomic) CGFloat originalOriginY;

@property (nonatomic, weak) UIButton * activeButton;
@property (nonatomic, strong) Subview * subview;

@property (weak, nonatomic) IBOutlet UIButton * genderButton;
@property (nonatomic) BOOL isMale;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isMale = NO;
    [self setTintColors];
    
    [[self navigationController] setNavigationBarHidden: YES animated: NO];

}

- (void) setTintColors
{
    UIImage *image = [_dressButton.imageView.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [[_dressButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [_dressButton setImage:image forState:UIControlStateNormal];
    _dressButton.tintColor = [UIColor blackColor];
    
    image = [_bagButton.imageView.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [[_bagButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [_bagButton setImage:image forState:UIControlStateNormal];
    _bagButton.tintColor = [UIColor blackColor];
    
    image = [_shoeButton.imageView.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [[_shoeButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [_shoeButton setImage:image forState:UIControlStateNormal];
    _shoeButton.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dressButtonTouched:(id)sender
{
    if (_activeButton) return;
    _activeButton = _dressButton;
    Subview * subview = [[Subview alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 460) type: ViewTypeDress selectedColor: _color1 delegate: self];
    [self.view addSubview: subview];
    [UIView animateWithDuration: 0.3 animations:^{
        _dressButton.transform = CGAffineTransformMakeScale(0.4, 0.4);
        [self moveViewToTopCenter: _dressButton];
        _bagButton.hidden = YES;
        _shoeButton.hidden = YES;
        
        CGRect frame = subview.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        subview.frame = frame;
    }];
    _genderButton.hidden = YES;
    
    _subview = subview;

}

- (IBAction)bagButtonTouched:(id)sender
{
    if (_activeButton) return;
    _activeButton = _bagButton;
    Subview * subview = [[Subview alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 460) type: ViewTypeBag selectedColor: _color2 delegate: self];
    [self.view addSubview: subview];
    [UIView animateWithDuration: 0.3 animations:^{
        [self moveViewToTopCenter: _bagButton];
        _shoeButton.hidden = YES;
        _dressButton.hidden = YES;
        
        CGRect frame = subview.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        subview.frame = frame;
    }];
    _genderButton.hidden = YES;

    _subview = subview;
}

- (IBAction)shoeButtonTouched:(id)sender
{
    if (_activeButton) return;
    _activeButton = _shoeButton;
    Subview * subview = [[Subview alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 460) type: ViewTypeShoe selectedColor: _color3 delegate: self];
    [self.view addSubview: subview];
    [UIView animateWithDuration: 0.3 animations:^{
        [self moveViewToTopCenter: _shoeButton];
        _bagButton.hidden = YES;
        _dressButton.hidden = YES;
        
        CGRect frame = subview.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        subview.frame = frame;
    }];
    _genderButton.hidden = YES;

    _subview = subview;

}

- (void) moveViewToTopCenter: (UIView *) view
{
    _originalOriginX = view.frame.origin.x;
    _originalOriginY = view.frame.origin.y;
    CGRect frame = view.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = 20;
    view.frame = frame;
}

- (void) subviewCanceled
{
    [self closeSubview];
}

- (void) closeSubview
{
    _genderButton.hidden = NO;
    UIView * activeView;
    if ([_activeButton isEqual: _dressButton])
    {
        activeView = _dressButton;
    } else if ([_activeButton isEqual: _bagButton])
    {
        activeView = _bagButton;
    } else {
        activeView = _shoeButton;
    }
    
    [UIView animateWithDuration: 0.3 animations:^{
        CGRect frame = activeView.frame;
        frame.origin.x = _originalOriginX;
        frame.origin.y = _originalOriginY;
        activeView.frame = frame;
        
        if ([activeView isEqual: _dressButton])
        {
            _dressButton.transform = CGAffineTransformMakeScale(1.0,1.0);
        }
        
        frame = _subview.frame;
        frame.origin.y = self.view.frame.size.height;
        _subview.frame = frame;
    } completion:^(BOOL finished) {
        _bagButton.hidden = _dressButton.hidden = _shoeButton.hidden = NO;
        _activeButton = nil;
        _subview = nil;
    }];
}

- (void) showHud
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) hideHud
{
    [MBProgressHUD hideHUDForView: self.view animated: YES];
}

- (void) userSelectedDress:(UIImage *)dressImage color:(UIColor *)selectedColor
{
    if ([_activeButton isEqual: _dressButton]) {
        [_dressButton setImage: dressImage forState: UIControlStateNormal];
        _color1 = selectedColor;
    } else if ([_activeButton isEqual: _bagButton]) {
        [_bagButton setImage: dressImage forState: UIControlStateNormal];
        _color2 = selectedColor;
    } else {
        [_shoeButton setImage: dressImage forState: UIControlStateNormal];
        _color3 = selectedColor;
    }
    [self closeSubview];
}

- (void) cameraButtonPressed
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Camera", @"Photo Library", nil];
    [actionSheet showInView: self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self showImagePickerFrom: buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void) showImagePickerFrom: (UIImagePickerControllerSourceType) source
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = source;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage * image = info [UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];
    
    UIColor * dominantColor = [self dominantColorFromImage: image];
    [self setSubviewColor: dominantColor];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIColor *) dominantColorFromImage: (UIImage *) image
{
    CCColorCube * colorCube = [[CCColorCube alloc] init];
    return [[colorCube extractBrightColorsFromImage: image avoidColor: nil count:1 ] firstObject];
}

- (void) setSubviewColor: (UIColor *) color
{
    [self.subview setColor: color];
    [_activeButton setTintColor: color];
}
- (void) showCamera
{
    [self showImagePickerFrom: UIImagePickerControllerSourceTypeCamera];
}

- (void) colorChanged:(UIColor *)color
{
    [_activeButton setTintColor: color];
}
- (IBAction)genderButtonPressed:(id)sender
{
    _isMale = !_isMale;
    [self refreshViewsForGender];
}

- (void) refreshViewsForGender
{
    if (_isMale)
    {
        [_dressButton setImage: [[UIImage imageNamed: @"shirt"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];
        [_shoeButton setImage: [[UIImage imageNamed: @"pants"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];
        [_bagButton setImage: [[UIImage imageNamed: @"shoeMan"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];

    } else {
        [_dressButton setImage: [[UIImage imageNamed: @"dress"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];
        [_shoeButton setImage: [[UIImage imageNamed: @"shoe"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];
        [_bagButton setImage: [[UIImage imageNamed: @"bag"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate ] forState: UIControlStateNormal];
    }
    [_genderButton setImage: [UIImage imageNamed: !_isMale ? @"man": @"woman"] forState: UIControlStateNormal];
    
    _color1 = nil;
    _color2 = nil;
    _color3 = nil;
    
    _dressButton.tintColor = [UIColor blackColor];
    _bagButton.tintColor = [UIColor blackColor];
    _shoeButton.tintColor = [UIColor blackColor];

}

- (BOOL)isMale
{
    return _isMale;
}

@end
