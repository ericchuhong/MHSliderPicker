//
//  MHSliderMenu.m
//  MHSliderPicker
//
//  Created by piggy on 16/8/8.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import "MHSliderMenu.h"

typedef enum : NSUInteger {
    MHSliderMenuMoveDirectionNone,
    MHSliderMenuMoveDirectionVertical,
    MHSliderMenuMoveDirectionHorizontal,
}MHSliderMenuMoveDirection;

static const int kMHSliderPickerItemSpace = 10;
static const int kMHSliderPickerInset = 0;


@implementation MHSliderMenu
{
    UIView *_menuView;
    NSArray *_items;
    
    CGFloat _minY;
    CGFloat _maxY;
    
    MHSliderPickerItem *_activeItem;
    MHSliderPickerItem *_selectedItem;
    MHSliderMenuMoveDirection _moveDirection;
}

@synthesize selectedItem = _selectedItem;

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems addDelegate:(id<MHSliderMenuDelegate>)delegate
{
    if (menuItems == nil || menuItems.count < 2)
    {
        [NSException raise:@"Menu items should be more than 2 items." format:nil];
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        _items = menuItems;
        self.delegate = delegate;
        
        [self _initialization];
    }
    return self;
}

- (void)layoutSubviews {
    if (!_menuView) {
#warning
        [self _setupMenus];
    }
    else
    {
#warning
        [self _relocateMenu];
    }
}


- (void)_initialization{
    _moveDirection = MHSliderMenuMoveDirectionNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.itemFont = [UIFont boldSystemFontOfSize:20];
//    self.itemBgColor = [UIColor colorWithRed:161 green:161 blue:161 alpha:0.7];
    self.itemTextColor = [UIColor colorWithRed:212 green:212 blue:212 alpha:0.5];
    self.itemCornerRadius = 5;
    self.highLightBgColor = UIColorFromRGB(0xFAB7CE);
    self.highlightTextColor = [UIColor whiteColor];
    self.menuBgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.menuBorderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    self.menuCornerRadius = 2.0f;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count != 1) {
        return ;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGPoint point = [touch locationInView:self];
    
    if (_moveDirection == MHSliderMenuMoveDirectionNone) {
        CGFloat xOffset = point.x - prePoint.x;
        CGFloat yOffset = point.y - prePoint.y;
        
        if ((fabsf(yOffset) - fabsf(xOffset)) > 0) {
            _moveDirection = MHSliderMenuMoveDirectionVertical;
        }
        else
        {
            _moveDirection = MHSliderMenuMoveDirectionHorizontal;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sliderMenuWillChangeSelectedItemValue:)]) {
                [self.delegate sliderMenuWillChangeSelectedItemValue:self];
            }
        }
    }
    
    if (_moveDirection == MHSliderMenuMoveDirectionVertical)
    {
        _menuView.hidden = NO;
        _activeItem.hidden = NO;
        
        CGFloat yOffset = point.y - prePoint.y;
        
        CGRect menuFrame = _menuView.frame;
        CGFloat newY = menuFrame.origin.y + yOffset;
        if (newY < _minY) {
            newY = _minY;
        }
        else if(newY > _maxY)
        {
            newY = _maxY;
        }
        
        _menuView.frame = CGRectMake(menuFrame.origin.x, newY, menuFrame.size.width, menuFrame.size.height);
        
        for (NSInteger i = 0; i < _items.count; i++)
        {
            MHSliderPickerItem *item = _items[i];
            CGPoint centerPointInMenuView = [self convertPoint:self.center toView:item];
            if ([item pointInside:centerPointInMenuView withEvent:nil]) {
                if (item != _selectedItem) {
                    _selectedItem.hidden = NO;
                    item.hidden = YES;
                    
                    _selectedItem = item;
                    _activeItem.text = _selectedItem.text;
                    _activeItem.currentLabel.text = _selectedItem.currentLabel.text;

                    if (self.delegate) {
                        [self.delegate sliderMenu:self didSelectItemIndex:i];
                    }
                }
            }
        }
        
    }
    else // Horizontal
    {
        CGFloat xOffset = point.x - prePoint.x;
        xOffset *= _selectedItem.factor;
        CGFloat newValue = _selectedItem.currentTValue + xOffset;
        if (newValue < _selectedItem.minValue) newValue = _selectedItem.minValue;
        if (newValue > _selectedItem.maxValue) newValue = _selectedItem.maxValue;
        
        _selectedItem.currentTValue = newValue;
        _selectedItem.currentValueText = [NSString stringWithFormat:@"%.0f",newValue];
        _selectedItem.currentLabel.text = [NSString stringWithFormat:@"%.0f",newValue];
        _activeItem.currentLabel.text = _selectedItem.currentLabel.text;
        if (self.delegate) {
            [self.delegate sliderMenuChangingSelectedItemValue:self];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_moveDirection == MHSliderMenuMoveDirectionHorizontal) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(sliderMenuDidChangeSelectedItemValue:)]) {
                [self.delegate sliderMenuDidChangeSelectedItemValue:self];
            }
        }
    }
    
    _moveDirection = MHSliderMenuMoveDirectionNone;
    _menuView.hidden = YES;
    _activeItem.hidden = YES;
}

- (CGSize)_calculateItemSize
{
    NSUInteger maxLength = 0;
    MHSliderPickerItem *maxItem;
    for (MHSliderPickerItem *item in _items) {
        if (item.text.length > maxLength) {
            maxLength = item.text.length;
            maxItem = item;
        }
    }
    CGSize itemSize = [MHSliderPickerItem itemsSizeForText:maxItem.text withFont:self.itemFont];
    itemSize.width = 200;
    return itemSize;
}

- (void)_setupMenus
{
    CGSize itemSize = [self _calculateItemSize];
    
    int menuViewWidth = itemSize.width + kMHSliderPickerInset * 2;
    int menuViewHeight = itemSize.height * _items.count + kMHSliderPickerItemSpace * (_items.count - 1) + kMHSliderPickerInset * 2;
    _minY = self.center.y + itemSize.height / 2.0 + kMHSliderPickerInset - menuViewHeight;
    _maxY = self.center.y - itemSize.height / 2.0 - kMHSliderPickerInset;
    
    _menuView = [[UIView alloc] init];
    _menuView.frame = CGRectMake(self.center.x - menuViewWidth / 2.0, _maxY, menuViewWidth, menuViewHeight);
    _menuView.hidden = YES;
    _menuView.opaque = NO;
    _menuView.layer.opaque = NO;
    _menuView.clipsToBounds = YES;
    _menuView.backgroundColor = self.menuBgColor;
    _menuView.layer.cornerRadius = self.menuCornerRadius;
//    _menuView.layer.borderWidth = 3;
//    _menuView.layer.borderColor = self.menuBorderColor.CGColor;
    _menuView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    CGFloat height = kMHSliderPickerInset;
    for (MHSliderPickerItem *item in _items) {
        item.font = self.itemFont;
        item.textColor = self.itemTextColor;
        item.backgroundColor = self.itemBgColor;
        item.frame = CGRectMake(kMHSliderPickerInset, height, itemSize.width, itemSize.height);
        height += itemSize.height + kMHSliderPickerItemSpace;
        [_menuView addSubview:item];
    }
    
    [self addSubview:_menuView];
    
    _selectedItem = _items[0];
    _selectedItem.hidden = YES;
    _activeItem = [[MHSliderPickerItem alloc] initWithText:_selectedItem.text];
    _activeItem.hidden = YES;
    _activeItem.backgroundColor = self.highLightBgColor;
    _activeItem.textColor = self.highlightTextColor;
    _activeItem.font = self.itemFont;
//    _activeItem.frame = CGRectMake(self.center.x - itemSize.width / 2.0, self.center.y - itemSize.height/2.0, itemSize.width, itemSize.height);
    _activeItem.frame = CGRectMake(self.center.x - itemSize.width / 2.0, self.center.y - itemSize.height / 2.0, itemSize.width, itemSize.height);
    _activeItem.layer.cornerRadius = 2.0f;
    _activeItem.clipsToBounds = YES;
    _activeItem.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_activeItem];

}

- (void)_relocateMenu
{
    CGSize itemSize = _selectedItem.frame.size;
    _minY = self.center.y + itemSize.height / 2.0 + kMHSliderPickerInset - _menuView.frame.size.height;
    _maxY = self.center.y - itemSize.height / 2.0 - kMHSliderPickerInset;
}


@end
