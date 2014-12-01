//
//  MPNewInfoDetail.m
//  JmrbNews
//
//  Created by dean on 13-1-14.
//
//

#import "MPNewInfoDetail.h"

@implementation MPNewInfoDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview
{
    //如何确定这个subview是播放视频的呢?
    //1.根据大小,它的大小是呢的程序屏幕区域大小
    //2.如果没有其他的subview会动态添加,那就这么地了吧,直接操作
    //3.其他的subview设置tag不为0,这个唯一0的就是它了
    //然后给superview的UIViewController发送什么什么操作
    
    NSLog(@"dddd");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
