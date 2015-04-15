//
//  ResultsViewController.m
//  Shades
//
//  Created by yücel uzun on 15/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import "ResultsViewController.h"
#import "ServiceInvoker.h"
#import "MBProgressHUD.h"

@interface ResultsViewController ()

@property (nonatomic) NSUInteger red;
@property (nonatomic) NSUInteger green;
@property (nonatomic) NSUInteger blue;

@property (nonatomic, strong) NSDictionary * tableData;

@end

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[ServiceInvoker serviceInvoker] getURL: [self createURL] responseBlock:^(id response, NSError * error) {
        _tableData = response;
        [MBProgressHUD hideHUDForView: self.view animated: YES];
    } fromViewController: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    CGFloat red, green, blue, alpha;
    [selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _red    = red *255;
    _green  = green * 255;
    _blue   = blue * 255;
}

- (NSString *) createURL
{
    NSString * url = [NSString stringWithFormat: @"http://5.101.97.25:3000/articles/%li,%li,%li", _red, _green, _blue];
    return url;
}

@end
