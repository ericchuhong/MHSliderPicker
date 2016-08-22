//
//  MHViewController.m
//  MHSliderPicker
//
//  Created by piggy on 16/8/8.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import "MHViewController.h"
#import "MHSliderMenu.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface MHViewController () <MHSliderMenuDelegate>

@property (nonatomic, readwrite, strong) UILabel *infoLabel;

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [self imageWithColor:UIColorFromRGB(0xA4E6FF) size:self.view.bounds.size];
    self.view.layer.contents = (id)image.CGImage;
    
    [self.view addSubview:self.infoLabel];
    [self setupMenu];
}

- (void)setupMenu {
    NSArray *items = @[[[MHSliderPickerItem alloc] initWithText:@"选择一"],[[MHSliderPickerItem alloc] initWithText:@"选择二"],[[MHSliderPickerItem alloc] initWithText:@"选择三"],[[MHSliderPickerItem alloc] initWithText:@"选择四"]];
    MHSliderMenu *menu = [[MHSliderMenu alloc] initWithFrame:self.view.frame menuItems:items addDelegate:self];
    menu.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:menu];
    
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Slider Menu Delegate
- (void)sliderMenu:(MHSliderMenu *)menu didSelectItemIndex:(NSInteger)index
{
    self.infoLabel.text = [NSString stringWithFormat:@"%@ : %.f", menu.selectedItem.text, menu.selectedItem.currentTValue];
}

- (void)sliderMenuChangingSelectedItemValue:(MHSliderMenu *)menu
{
    self.infoLabel.text = [NSString stringWithFormat:@"%@ : %.f", menu.selectedItem.text, menu.selectedItem.currentTValue];
}

#pragma mark - Getter And Setter 

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.frame = CGRectMake(0, 100, kScreenWidth, 40);
        _infoLabel.font = [UIFont systemFontOfSize:17.0f];
        _infoLabel.backgroundColor = UIColorFromRGB(0xFAB7CE);
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.text = @"值标签";
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _infoLabel;
}


@end
