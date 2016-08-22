//
//  MHSliderPickerItem.m
//  MHSliderPicker
//
//  Created by piggy on 16/8/8.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import "MHSliderPickerItem.h"

const static CGFloat KMHSliderMenuItemHInsert = 20;
const static CGFloat KMHSliderMenuItemVInsert = 3;

@implementation MHSliderPickerItem
{
    UILabel *_label;
}

@synthesize minValue;
@synthesize maxValue;
@synthesize currentTValue;

-(NSString *)text
{
    return _label.text;
}

- (void)setText:(NSString *)text
{
    _label.text = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    _label.textColor = textColor;
    _currentLabel.textColor = textColor;
}

- (UIFont *)font
{
    return _label.font;
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
}

- (id)initWithText:(NSString *)text
{

    self = [super init];
    if (self) {
        self.minValue = 0;
        self.maxValue = 100;
        self.currentTValue = 50;
        self.currentValueText = [NSString stringWithFormat:@"%.0f", self.currentTValue];
        self.factor = 1;
        
//        self.layer.cornerRadius = KMHSliderMenuItemHInsert;
//        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor colorWithRed:161 green:161 blue:161 alpha:0.7];
//        self.backgroundColor = [UIColor clearColor];
//        self.textColor = [UIColor colorWithRed:212 green:212 blue:212 alpha:1];

        _label = [[UILabel alloc] init];
        _label.textColor = self.textColor;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.text = text;
        [self addSubview:_label];
        
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.textColor = self.textColor;
        _currentLabel.textAlignment = NSTextAlignmentCenter;
//        _currentLabel.text = @"0";
        _currentLabel.text = self.currentValueText;
        
        [self addSubview:_currentLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = CGRectMake(KMHSliderMenuItemHInsert, KMHSliderMenuItemVInsert, self.bounds.size.width - KMHSliderMenuItemHInsert * 2, self.bounds.size.height - KMHSliderMenuItemVInsert * 2);
    _currentLabel.frame = CGRectMake(self.bounds.size.width - 2 * KMHSliderMenuItemHInsert, KMHSliderMenuItemVInsert, 30, self.bounds.size.height - KMHSliderMenuItemVInsert * 2);
}

+ (CGSize)itemsSizeForText:(NSString *)text withFont:(UIFont *)font
{
    CGRect textBound = [text boundingRectWithSize:CGSizeMake(9999, 9999) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    return CGSizeMake(KMHSliderMenuItemHInsert * 2 + textBound.size.width + 40, KMHSliderMenuItemVInsert * 2 + textBound.size.height);
}


@end
