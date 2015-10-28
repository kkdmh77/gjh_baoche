//
//  ShuiYaCell.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WarningDataListCell.h"
#import "DXPopover.h"

@interface WarningDataListCell ()

@end

@implementation WarningDataListCell

- (void)awakeFromNib {
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [_numberBtn setTitleColor:Common_LiteBlueColor forState:UIControlStateNormal];
    [_warningTimeBtn setTitleColor:Common_LiteBlueColor forState:UIControlStateNormal];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    // 添加手势
    // [self addLongPressGesture];
}

/*
- (IBAction)clickPressureValueBtn:(id)sender
{
    if (_handle) _handle(self, sender);
}

// 添加长按手势
- (void)addLongPressGesture
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel addGestureRecognizer:gesture];
    
    UILongPressGestureRecognizer *gestureOne = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
    _positionLabel.userInteractionEnabled = YES;
    [_positionLabel addGestureRecognizer:gestureOne];
    
}

- (void)showContent:(UILongPressGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    if (![view isKindOfClass:[UILabel class]]) return;
    
    if (UIGestureRecognizerStateBegan == gesture.state)
    {
        NSString *text = [NSString stringWithFormat:@" %@   ", ((UILabel *)view).text];
        CGFloat textWidth = MIN(IPHONE_WIDTH - 20, [text stringSizeWithFont:SP12Font].width);
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, 30)];
        textLabel.text = text;
        textLabel.backgroundColor = HEXCOLOR(0XF5F5F5);
        textLabel.font = SP12Font;
        
        DXPopover *popover = [DXPopover popover];
        [popover showAtPoint:CGPointMake(view.frameOriginX + textWidth / 2, self.frameOriginY + 44 + 45 + 30 + 20) popoverPostion:DXPopoverPositionDown withContentView:textLabel inView:[UIApplication sharedApplication].keyWindow];
    }
}
 */

+ (CGFloat)getCellHeight
{
    return 30;
}

- (void)loadDataWithShowEntity:(WarningDataListEntity *)entity
{
    [_numberBtn setTitle:entity.number forState:UIControlStateNormal];
    _warningTypeLabel.text = [NSString stringWithFormat:@"  %@", entity.warningType];
    _warningDateLabel.text = [NSString stringWithFormat:@"%@", entity.warningDate];
    [_warningTimeBtn setTitle:[NSString stringWithFormat:@"%@", entity.warningTime] forState:UIControlStateNormal];
}

@end
