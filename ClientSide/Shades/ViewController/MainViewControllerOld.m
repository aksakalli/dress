////
////  MainViewController.m
////  Shades
////
////  Created by yücel uzun on 15/04/15.
////  Copyright (c) 2015 Yücel Uzun. All rights reserved.
////
//
//#import "MainViewController.h"
//#import "CCColorCube.h"
//#import "PickerViewController.h"
//
//@interface MainViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MainViewControllerDelegate>
//
//@property (weak, nonatomic) IBOutlet UIButton *selectColorButton;
//@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
//@property (weak, nonatomic) IBOutlet UIButton *openPickerButton;
//@property (weak, nonatomic) IBOutlet UIButton *openCameraButton;
//
//@end
//
//@implementation MainViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear: animated];
//    [[self navigationController] setNavigationBarHidden: YES animated: NO];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//- (IBAction)showColorTypesPressed:(id)sender
//{
//    if (_openCameraButton.hidden) {
//        [self showColorTypes];
//    } else {
//        [self hideColorTypes];
//    }
//
//}
//
//- (void) showColorTypes
//{
//    _openCameraButton.alpha = 0;
//    _openPickerButton.alpha = 0;
//    _openPickerButton.hidden = NO;
//    _openCameraButton.hidden = NO;
//    [UIView animateWithDuration: 0.3 animations:^{
//        _openCameraButton.alpha = 1;
//        _openPickerButton.alpha = 1;
//        CGRect frame = _selectCategoryButton.frame;
//        frame.origin.y += _openCameraButton.frame.size.height + 20;
//        _selectCategoryButton.frame = frame;
//        _selectCategoryButton.alpha = 0.3;
//    }];
//}
//
//- (void) hideColorTypes
//{
//    if (_openCameraButton.hidden) return;
//    [UIView animateWithDuration: 0.3 animations:^{
//        _openCameraButton.alpha = 0;
//        _openPickerButton.alpha = 0;
//        CGRect frame = _selectCategoryButton.frame;
//        frame.origin.y -= _openCameraButton.frame.size.height + 20;
//        _selectCategoryButton.frame = frame;
//        _selectCategoryButton.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        _openPickerButton.hidden = YES;
//        _openCameraButton.hidden = YES;
//    }];
//}
//
//- (IBAction)showCategories:(id)sender
//{
//    [self hideColorTypes];
//}
//
//- (IBAction)openColorPicker:(id)sender
//{
//    [self showPickerViewControllerWithColor: nil];
//}
//
//- (IBAction)openCamera:(id)sender
//{
//    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Camera", @"Photo Library", nil];
//    [actionSheet showInView: self.view];
//}
//
//#pragma mark - UIActionSheetDelegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self showImagePickerFrom: buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary];
//}
//
//#pragma mark - Camera
//
//- (void) showImagePickerFrom: (UIImagePickerControllerSourceType) source
//{
//    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = source;
//
//    [self presentViewController:picker animated:YES completion:NULL];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    UIColor * dominantColor = [self dominantColorFromImage: info[UIImagePickerControllerOriginalImage]];
//    [self showPickerViewControllerWithColor: dominantColor];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (UIColor *) dominantColorFromImage: (UIImage *) image
//{
//    CCColorCube * colorCube = [[CCColorCube alloc] init];
//    return [[colorCube extractBrightColorsFromImage: image avoidColor: nil count:1 ] firstObject];
//}
//
//- (void) showPickerViewControllerWithColor: (UIColor *) color
//{
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PickerViewController * picker = (PickerViewController *) [sb instantiateViewControllerWithIdentifier:@"PickerViewController"];
//    [picker setSelectedColor: color];
//    picker.delegate = self;
//    [self.navigationController pushViewController: picker animated: YES ];
//}
//
//#pragma mark - MainViewControllerDelegate
//
//- (void) showCamera
//{
//    [self showImagePickerFrom: UIImagePickerControllerSourceTypeCamera];
//}
//
//@end
