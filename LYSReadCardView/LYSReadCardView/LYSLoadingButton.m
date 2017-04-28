//
//  LYSLoadingButton.m
//  LYSLoadingButton
//
//  Created by jk on 2017/4/19.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSLoadingButton.h"

static NSString *kLoadButtonStrokeAnimationKey = @"loadButton.stroke";

#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
@interface LYSLoadingButton ()<CAAnimationDelegate>{
#else
@interface LYSLoadingButton (){
#endif
    CGRect _originalFrame;
    CAShapeLayer *_loadingLayer;
    CGFloat _orginalCornerRadius;
}
    
@property(nonatomic,assign)BOOL isLoading;
    
@end
    
@implementation LYSLoadingButton
    
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       [self initConfig];
    }
    return self;
}
    
#pragma mark - 配置
-(void)initConfig{
        
    self.layer.masksToBounds = YES;
        
    // 是否正在加载
    _isLoading = NO;
        
    // 动画时间
    _duration = 1.5f;
        
    // 线的宽度
    _loadingLineWidth = 4.f;
    
    // 加载时，按钮不可用
    _disableWhenLoad = YES;
        
    // 加载颜色
    _loadingTintColor = [UIColor whiteColor];
        
    // 添加图层
    [self.layer addSublayer:self.loadingLayer];
        
    // 添加观察
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}
    
-(void)setIsLoading:(BOOL)isLoading{
    _isLoading = isLoading;
    self.titleLabel.alpha = self.isLoading ? 0.0 : 1.0;
    self.imageView.hidden = self.isLoading ? 0.0 : 1.0;
}
    
#pragma mark - dealloc方法
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
    
#pragma mark - 恢复动画
-(void)resumeAnimation{
    if (self.isLoading) {
        [self endLoading:nil];
        [self beginLoading];
    }
}
    
#pragma mark - 加载图层
-(CAShapeLayer*)loadingLayer{
    if (!_loadingLayer) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.strokeColor = self.loadingTintColor.CGColor;
        _loadingLayer.strokeEnd = 0;
        _loadingLayer.strokeStart = 0;
        _loadingLayer.lineWidth = self.loadingLineWidth;
    }
    return _loadingLayer;
}
    
    
#pragma mark - 切换动画
-(void)toggle{
    _isLoading ? [self endLoading:nil] : [self beginLoading];
}
    
    
#pragma mark - 开始加载
-(void)beginLoading{
    if (self.isLoading) {
        return;
    }
    _originalFrame = self.frame;
    _orginalCornerRadius = self.layer.cornerRadius;
    self.isLoading = YES;
    self.loadingLayer.hidden = NO;
    if(self.disableWhenLoad){
        self.userInteractionEnabled = NO;
    }
    __weak typeof (self) MySelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        CGFloat radius = MIN(MySelf.frame.size.height, MySelf.frame.size.width);
        MySelf.frame = CGRectMake((CGRectGetMinX(_originalFrame) + CGRectGetWidth(_originalFrame) / 2 - radius / 2), CGRectGetMinY(_originalFrame), radius, radius);
            MySelf.layer.cornerRadius = radius / 2;
    } completion:^(BOOL finished) {
        if(finished){
            [MySelf addLoadingAnimation];
        }
    }];
}
    
#pragma mark - 重写layoutSubviews方法
-(void)layoutSubviews{
    [super layoutSubviews];
    self.loadingLayer.frame = self.bounds;
    [self updatePath];
}
    
#pragma mark - 更新路径
- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.loadingLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.loadingLayer.path = path.CGPath;
    self.loadingLayer.strokeStart = 0.f;
    self.loadingLayer.strokeColor = self.loadingTintColor.CGColor;
    self.loadingLayer.strokeEnd = 0.f;
}
    
#pragma mark - 结束动画
-(void)endLoading:(void(^)())end{
    if (!self.isLoading) {
        return;
    }
    self.isLoading = NO;
    __weak typeof (self) MySelf = self;
    self.loadingLayer.hidden = YES;
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.35 animations:^{
        MySelf.frame = _originalFrame;
        MySelf.layer.cornerRadius = _orginalCornerRadius;
    } completion:^(BOOL finished) {
        if(finished){
            [MySelf.loadingLayer removeAnimationForKey:kLoadButtonStrokeAnimationKey];
            if(end){
                end();
            }
        }
    }];
}
    
#pragma mark - 添加动画
-(void)addLoadingAnimation{
        
    CABasicAnimation *headAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation.fromValue = @0;
    headAnimation.toValue = @0.25;
    headAnimation.duration = self.duration / 1.5;
    headAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
    CABasicAnimation *tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    tailAnimation.duration = self.duration / 1.5;
    tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endHeadAnimation.fromValue = @0.25;
    endHeadAnimation.toValue = @1;
    endHeadAnimation.beginTime = self.duration / 1.5;
    endHeadAnimation.duration = self.duration - (self.duration / 1.5);
    endHeadAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
    CABasicAnimation *endTailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endTailAnimation.fromValue = @1;
    endTailAnimation.toValue = @1;
    endTailAnimation.beginTime = self.duration / 1.5;
    endTailAnimation.duration = self.duration - (self.duration / 1.5);
    endTailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
    CAAnimationGroup *_group = [CAAnimationGroup animation];
    _group.animations = @[headAnimation,tailAnimation,endHeadAnimation,endTailAnimation];
    _group.duration = self.duration;
    _group.repeatCount = INFINITY;
    _group.removedOnCompletion = NO;
    _group.delegate = self;
    _group.fillMode = kCAFillModeForwards;
    [self.loadingLayer addAnimation:_group forKey:kLoadButtonStrokeAnimationKey];
}
    
@end
