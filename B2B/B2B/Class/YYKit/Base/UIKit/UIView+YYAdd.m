//
//  UIView+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIView+YYAdd.h"
#import <QuartzCore/QuartzCore.h>
#import "YYKitMacro.h"

#define kTransitionTime 0.55
#define kFlipTime       0.85
#define DEGREES_TO_RADIANS(d)   (d * M_PI / 180)

YYSYNTH_DUMMY_CLASS(UIView_YYAdd)


@implementation UIView (YYAdd)

NSMutableDictionary *staticDrawLineViewAttributesDic = nil;

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}


- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 自定义添加
/**************************** 自定义添加 ********************************/

+ (UIView *)reflectImage:(UIImage *)image withFrame:(CGRect)frame opacity:(CGFloat)opacity atView:(UIView *)view
{
    // Image Layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (id)image.CGImage;
    imageLayer.frame = frame;
    //	imageLayer.borderColor = [UIColor darkGrayColor].CGColor;
    //	imageLayer.borderWidth = 6.0;
    [view.layer addSublayer:imageLayer];
    
    // Reflection Layer
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = imageLayer.contents;
    reflectionLayer.frame = CGRectMake(imageLayer.frame.origin.x, imageLayer.frame.origin.y + imageLayer.frame.size.height, imageLayer.frame.size.width, imageLayer.frame.size.height);
    //	reflectionLayer.borderColor = imageLayer.borderColor;
    //	reflectionLayer.borderWidth = imageLayer.borderWidth;
    reflectionLayer.opacity = opacity;
    // Transform X by 180 degrees
    [reflectionLayer setValue:[NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)] forKeyPath:@"transform.rotation.x"];
    
    // Gradient Layer - Use as mask
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0.5, 0.6);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
    // Add gradient layer as a mask
    reflectionLayer.mask = gradientLayer;
    [view.layer addSublayer:reflectionLayer];
    
    return view;
}

- (UIView *)addLineWithPosition:(ViewDrawLinePostionType)position lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth
{
    return [self addLineWithPosition:position startPointOffset:0 endPointOffset:0 lineColor:lineColor lineWidth:lineWidth];
}

- (UIView *)addLineWithPosition:(ViewDrawLinePostionType)position startPointOffset:(CGFloat)startOffset endPointOffset:(CGFloat)endOffset lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth
{
    if (!staticDrawLineViewAttributesDic)
    {
        staticDrawLineViewAttributesDic = [NSMutableDictionary dictionary];
    }
    
    static NSString * const PositionKey     = @"PositionKey";
    static NSString * const ColorKey        = @"ColorKey";
    static NSString * const WidthKey        = @"WidthKey";
    
    NSString *attributeKeyStr = [NSString stringWithFormat:@"%@",self];
    
    NSMutableArray *attributeArray = [staticDrawLineViewAttributesDic objectForKey:attributeKeyStr];
    if (!attributeArray)
    {
        attributeArray = [NSMutableArray array];
        [staticDrawLineViewAttributesDic setObject:attributeArray forKey:attributeKeyStr];
    }
    
    // 不画重复位置的线
    for (NSDictionary *attributeDic in attributeArray)
    {
        NSInteger linePosition = [[attributeDic objectForKey:PositionKey] integerValue];
        
        if (position == linePosition) return nil;
    }
    
    // 存入属性
    NSDictionary *newAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:position], PositionKey,
                                     lineColor, ColorKey,
                                     [NSNumber numberWithFloat:lineWidth],WidthKey, nil];
    [attributeArray addObject:newAttributeDic];
    [staticDrawLineViewAttributesDic setObject:attributeArray forKey:attributeKeyStr];
    
    // 开始划线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    switch (position)
    {
        case ViewDrawLinePostionType_Top:
        {
            lineView.frame = CGRectMake(startOffset, 0, self.boundsWidth - startOffset - endOffset, lineWidth);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        }
            break;
        case ViewDrawLinePostionType_Bottom:
        {
            lineView.frame = CGRectMake(startOffset, self.boundsHeight - lineWidth, self.boundsWidth - startOffset - endOffset, lineWidth);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }
            break;
        case ViewDrawLinePostionType_Left:
        {
            lineView.frame = CGRectMake(0, startOffset, lineWidth, self.boundsHeight - startOffset - endOffset);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        }
            break;
        case ViewDrawLinePostionType_Right:
        {
            lineView.frame = CGRectMake(self.boundsWidth - lineWidth, startOffset, lineWidth, self.boundsHeight - startOffset - endOffset);
            lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        }
            break;
            
        default:
            break;
    }
    return lineView;
}

- (NSArray *)superviews {
    NSMutableArray *superviews = [[NSMutableArray alloc] init];
    
    UIView *view = self;
    UIView *superview = nil;
    while (view) {
        superview = [view superview];
        if (!superview) {
            break;
        }
        
        [superviews addObject:superview];
        view = superview;
    }
    
    return superviews;
}

/**************************** 动画 ********************************/

- (void)startRotationAnimatingWithDuration:(CGFloat)duration
{
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = duration;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALL;
    
    [self.layer setShouldRasterize:YES];//抗锯齿
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [self.layer addAnimation:animation forKey:nil];
    
    //如果暂停了，则恢复动画运行
    if (self.layer.speed == 0.0)
    {
        [self resumeAnimating];
    }
}

- (void)stopRotationAnimating
{
    [self.layer removeAllAnimations];
}

- (void)pauseAnimating
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resumeAnimating
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}


- (void)animationRevealWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:direction];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationFadeWithExecuteBlock:(animationExecuteBlock)block
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationRotateAndScaleDownUpWithExecuteBlock:(animationExecuteBlock)block
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 2];
    rotationAnimation.duration = 0.750f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.duration = 0.75f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.75f;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = 1;//HUGE_VALF;
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil]];
    
    block();
    
    [self.layer addAnimation:animationGroup forKey:@"animationGroup"];
}


- (void)animationFlipWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kFlipTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"oglFlip"];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationPushWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCurlWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"pageCurl"];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationUnCurlWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"pageUnCurl"];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationRotateAndScaleEffectsWithExecuteBlock:(animationExecuteBlock)block
{
    [UIView animateWithDuration:0.75 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80) ];// 旋转形成一道闪电。
        // animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) ];// y轴居中对折番。
        // animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0) ];// 沿X轴对折翻转。
        // animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.50, -0.50, 0.50) ];
        // animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2) ];
        
        animation.duration = 0.45;
        animation.repeatCount = 1;
        
        block();
        
        [self.layer addAnimation:animation forKey:nil];
        
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
         ];
    }
     ];
}

- (void)animationMoveWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCubeWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:direction];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationRippleEffectWithExecuteBlock:(animationExecuteBlock)block
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"rippleEffect"];
    [animation setSubtype:kCATransitionFromRight];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCameraEffectWithExecuteBlock:(animationExecuteBlock)block type:(NSString *)type
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:type];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationSuckEffectWithExecuteBlock:(animationExecuteBlock)block
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"suckEffect"];
    [animation setSubtype:kCATransitionFromRight];
    
    block();
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationBounceInWithExecuteBlock:(animationExecuteBlock)block
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0001];
    [self setAlpha:0.8];
    [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
    
    block();
    
    [UIView commitAnimations];
}

- (void)animationBounceOutWithExecuteBlock:(animationExecuteBlock)block
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.73];
    // [UIView setAnimationDelay:0.2];
    [self setAlpha:1.0];
    [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
    
    block();
    
    [UIView commitAnimations];
}

- (void)animationBounceWithExecuteBlock:(animationExecuteBlock)block
{
    CGRect rect = self.bounds;
    CGPoint center = self.center;
    [self setCenter:CGPointMake(160, 240)];
    [self setFrame:CGRectZero];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [self setAlpha:1.0];
    [self setBounds:rect];
    [self setCenter:center];
    
    block();
    
    [UIView commitAnimations];
}

@end
