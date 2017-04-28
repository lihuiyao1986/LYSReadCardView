//
//  LYSLoadingButton.h
//  LYSLoadingButton
//
//  Created by jk on 2017/4/19.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSLoadingButton : UIButton

#pragma mark - 是否正在加载
@property(nonatomic,assign,readonly)BOOL isLoading;

#pragma mark - 每次动画运行的时间
@property(nonatomic,assign)NSTimeInterval duration;

#pragma mark - 线宽度
@property(nonatomic,assign)CGFloat loadingLineWidth;

#pragma mark - 加载线的颜色
@property(nonatomic,strong)UIColor *loadingTintColor;

#pragma mark - 加载层
@property(nonatomic,strong,readonly)CAShapeLayer *loadingLayer;

#pragma mark - 加载时是否disable按钮
@property(nonatomic,assign)BOOL disableWhenLoad;

#pragma mark - 开始加载
-(void)beginLoading;

#pragma mark - 停止加载
-(void)endLoading:(void(^)())end;

#pragma mark - 切换
-(void)toggle;


@end
