//
//  LYSReadCardView.h
//  test
//
//  Created by jk on 2017/4/27.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSReadCardView : UIView

#pragma mark - 按钮的颜色
@property(nonatomic,strong)UIColor *loadBtnBgColor;

#pragma mark - 正常时的颜色
@property(nonatomic,strong)UIColor *normalTextColor;

#pragma mark - 异常时的颜色
@property(nonatomic,strong)UIColor *abnormalTextColor;

#pragma mark - 加载按钮点击回调
@property(nonatomic,copy)void(^LoadingBtnClickBlock)();

#pragma mark - 关闭视图回调
@property(nonatomic,copy)void(^CloseWinBlock)();

#pragma mark - 点击外面是否取消
@property(nonatomic,assign)BOOL dismissTouchOutside;

#pragma mark - 是否正在读卡
@property(nonatomic,assign,readonly)BOOL isReadingCard;

#pragma mark - 加载中按钮的标题
@property(nonatomic,copy)NSString *loadingBtnTitle;

#pragma mark - 开始读卡
-(void)startRead:(void(^)())completion;

#pragma mark - 停止读卡
-(void)stopRead:(void(^)())completion;

#pragma mark - 关闭
-(void)dismiss:(void(^)())completion;

#pragma mark - 显示
-(void)show:(void(^)())completion;

#pragma mark - 显示
-(void)showInView:(UIView*)view completion:(void(^)())completion;

#pragma mark - 更新提示信息
-(void)updateTipInfo:(BOOL)succ tipText:(NSString*)tipText;

@end
