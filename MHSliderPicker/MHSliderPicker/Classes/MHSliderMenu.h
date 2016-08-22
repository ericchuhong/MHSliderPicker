//
//  MHSliderMenu.h
//  MHSliderPicker
//
//  Created by piggy on 16/8/8.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSliderPickerItem.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@protocol MHSliderMenuDelegate;

@interface MHSliderMenu : UIView

@property (nonatomic,strong,readonly) MHSliderPickerItem *selectedItem;
@property (nonatomic,weak) id<MHSliderMenuDelegate> delegate;

@property (nonatomic,strong) UIFont *itemFont;
@property (nonatomic,strong) UIColor *itemTextColor;
@property (nonatomic,strong) UIColor *itemBgColor;
@property (nonatomic) CGFloat itemCornerRadius;
@property (nonatomic,strong) UIColor *highLightBgColor;
@property (nonatomic,strong) UIColor *highlightTextColor;
@property (nonatomic,strong) UIColor *menuBgColor;
@property (nonatomic,strong) UIColor *menuBorderColor;
@property (nonatomic,assign) CGFloat menuCornerRadius;

-(instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems addDelegate:(id<MHSliderMenuDelegate>)delegate;
@end
@protocol MHSliderMenuDelegate <NSObject>

- (void)sliderMenu:(MHSliderMenu *)menu didSelectItemIndex:(NSInteger)index;
- (void)sliderMenuChangingSelectedItemValue:(MHSliderMenu *)menu;

@optional
- (void)sliderMenuWillChangeSelectedItemValue:(MHSliderMenu *)menu;
- (void)sliderMenuDidChangeSelectedItemValue:(MHSliderMenu *)menu;

@end
