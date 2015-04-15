//
//  Subview.h
//  Shades
//
//  Created by yücel uzun on 15/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubviewDelegate

- (void) subviewCanceled;
- (void) showHud;
- (void) hideHud;

- (void) colorChanged: (UIColor *) color;
- (void) cameraButtonPressed;

- (void) userSelectedDress: (UIImage *) dressImage color: (UIColor *) selectedColor;

- (BOOL) isMale;

@end

typedef NS_ENUM(NSUInteger, ViewType) {
    ViewTypeDress,
    ViewTypeShoe,
    ViewTypeBag
};

@interface Subview : UIView

@property (nonatomic, weak) id <SubviewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame type: (ViewType) type selectedColor: (UIColor *) color delegate: (id <SubviewDelegate>) delegate;

- (void) setColor: (UIColor *) color;

@end
