//
//  LYSReadCardView.m
//  test
//
//  Created by jk on 2017/4/27.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSReadCardView.h"
#import "LYSLoadingButton.h"

@interface LYSReadCardView ()

#pragma mark - 加载按钮
@property(nonatomic,strong)LYSLoadingButton *loadingBtn;

#pragma mark - 内层容器视图
@property(nonatomic,strong)UIView *innerContainerView;

#pragma mark - 外层容器视图
@property(nonatomic,strong)UIView *outerContainerView;

#pragma mark - 读卡器的icon
@property(nonatomic,strong)UIImageView *readerIcon;

#pragma mark - 提示视图
@property(nonatomic,strong)UILabel *tipLb;

#pragma mark - 关闭按钮
@property(nonatomic,strong)UIButton *closeBtn;

#pragma mark - 动画时间
@property(nonatomic,assign)NSTimeInterval duration;

@end

@implementation LYSReadCardView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initConfig];
    }
    return self;
}


#pragma mark - 缩放x
-(CGFloat)scaleX:(CGFloat)size{
    if ([UIScreen mainScreen].bounds.size.height > 480.f) {
        size = size * ([UIScreen mainScreen].bounds.size.width / 320.f);
    }
    return size;
}

#pragma mark - 缩放y
-(CGFloat) scaleY:(CGFloat)size{
    if ([UIScreen mainScreen].bounds.size.height > 480.f) {
        size = size * ([UIScreen mainScreen].bounds.size.height / 568.f);
    }
    return size;
}

-(void)setLoadBtnBgColor:(UIColor *)loadBtnBgColor{
    _loadBtnBgColor = loadBtnBgColor;
    self.loadingBtn.backgroundColor = self.loadBtnBgColor;
}

#pragma mark - 初始化配置
-(void)initConfig{
    [self setDefaults];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self addSubview:self.outerContainerView];
    [self.outerContainerView addSubview:self.innerContainerView];
    [self.outerContainerView addSubview:self.closeBtn];
    [self.innerContainerView addSubview:self.readerIcon];
    [self.innerContainerView addSubview:self.tipLb];
    [self.innerContainerView addSubview:self.loadingBtn];
}


-(void)setLoadingBtnTitle:(NSString *)loadingBtnTitle{
    _loadingBtnTitle = loadingBtnTitle;
    [self.loadingBtn setTitle:loadingBtnTitle forState:UIControlStateNormal];
    [self.loadingBtn setTitle:loadingBtnTitle forState:UIControlStateHighlighted];
}

#pragma mark - layoutSubviews方法重写
-(void)layoutSubviews{
    [super layoutSubviews];
    self.outerContainerView.frame = CGRectMake([self scaleX:20.f], (CGRectGetHeight(self.frame) - [self scaleY:280.f]) / 2, CGRectGetWidth(self.frame) - [self scaleX:40.f] , [self scaleY:280.f]);
    self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.outerContainerView.frame) - self.closeBtn.imageView.image.size.width, 0, self.closeBtn.imageView.image.size.width, self.closeBtn.imageView.image.size.height);
    self.innerContainerView.frame = CGRectMake(CGRectGetWidth(self.closeBtn.frame) / 2, CGRectGetWidth(self.closeBtn.frame) / 2, CGRectGetWidth(self.outerContainerView.frame) - CGRectGetWidth(self.closeBtn.frame), CGRectGetHeight(self.outerContainerView.frame) - CGRectGetHeight(self.closeBtn.frame));
    self.readerIcon.frame = CGRectMake(0, 0, CGRectGetWidth(self.innerContainerView.frame), CGRectGetHeight(self.innerContainerView.frame) * 0.6);
    self.tipLb.frame = CGRectMake([self scaleX:10.f], CGRectGetMaxY(self.readerIcon.frame), CGRectGetWidth(self.innerContainerView.frame) - [self scaleX:20.f], [self scaleX:40.f]);
    self.loadingBtn.frame = CGRectMake([self scaleX:40.f],CGRectGetHeight(self.innerContainerView.frame) - [self scaleY:40.f] - [self scaleY:15.f], CGRectGetWidth(self.innerContainerView.frame) - [self scaleX:80.f], [self scaleY:40.f]);
}

#pragma mark - 关闭按钮
-(UIButton*)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"LYSReadCardView.bundle/close"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"LYSReadCardView.bundle/close"] forState:UIControlStateHighlighted];
        [_closeBtn setImage:[UIImage imageNamed:@"LYSReadCardView.bundle/close"] forState:UIControlStateSelected];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIView*)innerContainerView{
    if (!_innerContainerView) {
        _innerContainerView = [UIView new];
        _innerContainerView.backgroundColor = [UIColor whiteColor];
        _innerContainerView.layer.cornerRadius = 5.f;
        _innerContainerView.layer.masksToBounds = YES;
    }
    return _innerContainerView;
}


-(UIView*)outerContainerView{
    if (!_outerContainerView) {
        _outerContainerView = [UIView new];
        _outerContainerView.backgroundColor = [UIColor clearColor];
    }
    return _outerContainerView;
}

#pragma mark - 关闭按钮被点击
-(void)closeBtnClicked:(UIButton*)sender{
    [self dismiss:nil];
}

#pragma mark - 提示标签
-(UILabel*)tipLb{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.numberOfLines = 2;
        _tipLb.lineBreakMode = NSLineBreakByWordWrapping;
        _tipLb.font = [UIFont systemFontOfSize:14];
        _tipLb.text = @"请先插好IC卡，准备读取卡信息!";
        _tipLb.textColor = self.normalTextColor;
    }
    return _tipLb;
}

#pragma mark - 生成16进制颜色
-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark - 读卡图标
-(UIImageView*)readerIcon{
    if (!_readerIcon) {
        _readerIcon = [[UIImageView alloc]init];
        _readerIcon.image = [UIImage imageNamed:@"LYSReadCardView.bundle/card_read_icon"];
        _readerIcon.animationDuration = 1.5;
        _readerIcon.contentMode = UIViewContentModeCenter;
        _readerIcon.animationRepeatCount = 0;
        _readerIcon.backgroundColor = [self colorWithHexString:@"f7f7f7" alpha:1.0];
        _readerIcon.animationImages = @[
                                        [UIImage imageNamed:@"LYSReadCardView.bundle/card_read_icon_1"],
                                        [UIImage imageNamed:@"LYSReadCardView.bundle/card_read_icon_2"],
                                        [UIImage imageNamed:@"LYSReadCardView.bundle/card_read_icon_3"]];
    }
    return _readerIcon;
}

#pragma mark - 加载按钮
-(LYSLoadingButton*)loadingBtn{
    if (!_loadingBtn) {
        _loadingBtn = [LYSLoadingButton buttonWithType:UIButtonTypeCustom];
        _loadingBtn.disableWhenLoad = YES;
        _loadingBtn.layer.cornerRadius = 8.f;
        _loadingBtn.layer.masksToBounds = YES;
        [_loadingBtn setTitle:self.loadingBtnTitle forState:UIControlStateNormal];
        [_loadingBtn setTitle:self.loadingBtnTitle forState:UIControlStateHighlighted];
        [_loadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _loadingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _loadingBtn.backgroundColor = self.loadBtnBgColor;
        [_loadingBtn addTarget:self action:@selector(loadingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loadingBtn;
}

#pragma mark - 更新提示信息
-(void)updateTipInfo:(BOOL)succ tipText:(NSString*)tipText{
    self.tipLb.textColor = succ ? self.normalTextColor : self.abnormalTextColor;
    self.tipLb.text = tipText;
}

#pragma mark - 加载按钮被点击
-(void)loadingBtnClicked:(UIButton*)sender{
    [self startRead:self.LoadingBtnClickBlock];
}

#pragma mark - 设置默认值
-(void)setDefaults{
    _duration = 0.35;
    _loadingBtnTitle = @"开始读卡";
    _normalTextColor = [self colorWithHexString:@"414114" alpha:1.0];
    _abnormalTextColor = [UIColor redColor];
    _loadBtnBgColor = [self colorWithHexString:@"65c5e9" alpha:1.0];
    _isReadingCard = NO;
}

#pragma mark - 点击回调
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.outerContainerView.frame, point)) {
        if (self.dismissTouchOutside && !self.isReadingCard) {
            [self dismiss:nil];
        }
    }
}

#pragma mark - 开始读卡
-(void)startRead:(void(^)())completion{
    if (!self.isReadingCard) {
        [self.loadingBtn beginLoading];
        _isReadingCard = YES;
        [self.readerIcon startAnimating];
        self.closeBtn.hidden = YES;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - 停止读卡
-(void)stopRead:(void(^)())completion{
    if (self.isReadingCard) {
        [self.loadingBtn endLoading:nil];
        [self.readerIcon stopAnimating];
        _isReadingCard = NO;
        self.closeBtn.hidden = NO;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - 显示
-(void)showInView:(UIView*)view completion:(void(^)())completion{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    self.alpha = 0;
    self.outerContainerView.transform = CGAffineTransformMakeScale(0.1,0.1);
    __weak typeof (self)MyWeakSelf = self;
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        MyWeakSelf.outerContainerView.transform = CGAffineTransformMakeScale(1.0,1.0);
        MyWeakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

#pragma mark - 显示
-(void)show:(void(^)())completion{
    [self showInView:nil completion:completion];
}

#pragma mark - 关闭
-(void)dismiss:(void(^)())completion{
    __weak typeof (self)MyWeakSelf = self;
    [UIView animateWithDuration:self.duration animations:^{
        MyWeakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [MyWeakSelf removeFromSuperview];
        if (completion) {
            completion();
        }
        if (MyWeakSelf.CloseWinBlock) {
            MyWeakSelf.CloseWinBlock();
        }
    }];
}

@end
