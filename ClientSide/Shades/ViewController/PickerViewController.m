////
////  PickerViewController.m
////  Shades
////
////  Created by yücel uzun on 15/04/15.
////  Copyright (c) 2015 Yücel Uzun. All rights reserved.
////
//
//#import "PickerViewController.h"
//#import "RGBColorSlider.h"
//#import "RGBColorSliderDelegate.h"
//
//@interface PickerViewController ()  <RGBColorSliderDataOutlet>
//
//@property (nonatomic, strong) UIColor * selectedColor;
//
//@property (nonatomic, strong) RGBColorSlider * redSlider;
//@property (nonatomic, strong) RGBColorSlider * greenSlider;
//@property (nonatomic, strong) RGBColorSlider * blueSlider;
//
//@property (weak, nonatomic) IBOutlet UILabel *label;
//@property (weak, nonatomic) IBOutlet UIButton *yesButton;
//@property (weak, nonatomic) IBOutlet UIButton *redoButton;
//
//@property (nonatomic) BOOL defaultPicker;
//@end
//
//@implementation PickerViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self initSlider];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear: animated];
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    if (self.defaultPicker)
//    {
//        [self editButtonTouched: nil];
//    }
//}
//
//- (void) initSlider
//{
//    RGBColorSliderDelegate *delegate = [[RGBColorSliderDelegate alloc] init];
//    delegate.delegate = self;
//    
//    _redSlider = [[RGBColorSlider alloc] initWithFrame:CGRectMake(20, 200, 280, 44) sliderColor: RGBColorTypeRed trackHeight: 15 delegate:delegate];
//    _greenSlider = [[RGBColorSlider alloc] initWithFrame:CGRectMake(20, 244, 280, 44) sliderColor: RGBColorTypeGreen trackHeight: 15 delegate:delegate];
//    _blueSlider = [[RGBColorSlider alloc] initWithFrame:CGRectMake(20, 288, 280, 44) sliderColor: RGBColorTypeBlue trackHeight: 15 delegate:delegate];
//    
//    [self.view addSubview: _redSlider];
//    [self.view addSubview: _greenSlider];
//    [self.view addSubview: _blueSlider];
//    
//    _redSlider.alpha = 0;
//    _greenSlider.alpha = 0;
//    _blueSlider.alpha = 0;
//}
//
//- (void)setSelectedColor:(UIColor *)selectedColor
//{
//    if (selectedColor == nil)
//    {
//        selectedColor = [UIColor colorWithRed: 212.0 / 255.0 green: 105.0 / 255.0 blue: 43.0 / 255.0 alpha: 1];
//        self.defaultPicker = YES;
//    }
//    
//    self.view.backgroundColor = selectedColor;
//    
//    CGFloat red, green, blue, alpha;
//    [selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
//        
//    _redSlider.value = red;
//    _greenSlider.value = green;
//    _blueSlider.value = blue;
//}
//
//#pragma mark -  RGBColorSliderDataOutlet
//
//- (void)updateColor:(UIColor *)color
//{
//    self.view.backgroundColor = color;
//}
//
//#pragma mark - Button actions
//
//- (IBAction)yesButtonTouched:(id)sender
//{
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PickerViewController * results = (PickerViewController *) [sb instantiateViewControllerWithIdentifier:@"ResultsViewController"];
//    [results setSelectedColor: self.selectedColor];
//    [self.navigationController pushViewController: results animated: YES ];
//}
//
//- (IBAction)editButtonTouched:(id)sender
//{
//    [UIView animateWithDuration: 0.3 animations:^{
//        _label.text = @"Edit your color as you want";
//        
//        CGRect frame = _label.frame;
//        frame.origin.y = 64;
//        _label.frame = frame;
//        
//        frame = _yesButton.frame;
//        frame.origin.y = self.view.frame.size.height - frame.size.height - 20;
//        _yesButton.frame = frame;
//        
//        frame = _redoButton.frame;
//        frame.origin.y = self.view.frame.size.height - frame.size.height - 20;
//        _redoButton.frame = frame;
//        
//        _editButton.alpha = 0;
//        _redSlider.alpha = _greenSlider.alpha = _blueSlider.alpha = 1;
//    }];
//}
//
//- (IBAction)redoButtonTouched:(id)sender
//{
//    [self.navigationController popViewControllerAnimated: NO];
//    [self.delegate showCamera];
//}
//
//@end
