//
//  PickerViewController.h
//  Shades
//
//  Created by yücel uzun on 15/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate <NSObject>

- (void) showCamera;

@end

@interface PickerViewController : UIViewController

@property (nonatomic, weak) id <MainViewControllerDelegate> delegate;

- (void)setSelectedColor:(UIColor *)selectedColor;

@end
