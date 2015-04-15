////
////  MainViewController.m
////  Shades
////
////  Created by yücel uzun on 14/04/15.
////  Copyright (c) 2015 Yücel Uzun. All rights reserved.
////
//
//#import "MainViewControllerOld.h"
//#import "CCColorCube.h"
//
//@interface MainViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//
//@property (nonatomic, strong) UIColor * dominantColorInImage;
//
//@end
//
//@implementation MainViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - UIActionSheet
//- (IBAction)showColorSelections:(id)sender {
//}
//
//- (IBAction)selectPhoto:(id)sender
//{
//    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Camera", @"Photo Library", nil];
//    [actionSheet showInView: self.view];
//}
//
//- (IBAction)openColorPicker:(id)sender {
//}
//- (IBAction)openCamera:(id)sender {
//}
//- (IBAction)openColorPicker:(id)sender {
//}
//#pragma mark UIActionSheetDelegate
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
//    UIImage * chosenImage = info[UIImagePickerControllerOriginalImage];
//    CCColorCube * colorCube = [[CCColorCube alloc] init];
//    
//    NSArray *imgColors = [colorCube extractBrightColorsFromImage: chosenImage avoidColor: nil count:1 ];
//    _dominantColorInImage = imgColors[0];
//    [self.view setBackgroundColor: _dominantColorInImage];
//    
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (IBAction)colorSlider:(UISlider * )sender
//{
//    CGFloat hue, saturation, brightness, alpha;
//    [_dominantColorInImage getHue: &hue saturation: &saturation brightness: &brightness alpha: &alpha];
//    UIColor * newColor = [UIColor colorWithHue: hue * sender.value saturation: saturation * sender.value brightness: brightness * sender.value alpha: alpha];
//    [self.view setBackgroundColor: newColor];
//}
//
//@end
