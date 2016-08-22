//
//  MHSliderPickerItem.h
//  MHSliderPicker
//
//  Created by piggy on 16/8/8.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHSliderPickerItem : UIView

@property (nonatomic) CGFloat minValue;

@property (nonatomic) CGFloat maxValue;

@property (nonatomic) CGFloat currentTValue;

@property (nonatomic) CGFloat factor;

@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) NSString *currentValueText;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UILabel *currentLabel;

+ (CGSize)itemsSizeForText:(NSString *)text withFont:(UIFont *)font;

- (id)initWithText:(NSString *)text;

@end

@interface MHSliderPickerItem(MHSliderPickerItemObject)



@end