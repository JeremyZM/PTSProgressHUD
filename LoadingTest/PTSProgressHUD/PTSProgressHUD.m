//
//  PTSProgressHUD.m
//  LoadingTest
//
//  Created by 黄杰 on 15/11/27.
//  Copyright © 2015年 黄杰. All rights reserved.
//

#import "PTSProgressHUD.h"

NSString * const PTSProgressHUDDidReceiveTouchEventNotification = @"PTSProgressHUDDidReceiveTouchEventNotification";
NSString * const PTSProgressHUDDidTouchDownInsideNotification = @"PTSProgressHUDDidTouchDownInsideNotification";
NSString * const PTSProgressHUDWillDisappearNotification = @"PTSProgressHUDWillDisappearNotificationn";
NSString * const PTSProgressHUDDidDisappearNotificationn = @"PTSProgressHUDDidDisappearNotificationn";
NSString * const PTSProgressHUDWillShowAnimationNotificationn = @"PTSProgressHUDWillShowAnimationNotificationn";
NSString * const PTSProgressHUDDidShowAnimationNotificationn = @"PTSProgressHUDDidShowAnimationNotificationn";

NSString * const PTSProgressHUDStatusUserInfoKey = @"PTSProgressHUDStatusUserInfoKey";

@interface PTSProgressHUD () {
    BOOL _isInitializing;
}
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) YYAnimatedImageView *gifImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *gitImageCenterX;
@property (nonatomic, strong) NSLayoutConstraint *gitImageCenterY;
@property (nonatomic, assign) BOOL hasLoadImg;

@end

@implementation PTSProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isInitializing = YES;
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.userInteractionEnabled = NO;
        _bgColor = [UIColor whiteColor];
        _titleColor = [UIColor blackColor];
        _titleSize = [UIFont systemFontOfSize:17];
        _titleMargin = 10;
        _gifImgRatio = 0.2;
        self.alpha = 0.0;
        self.hudView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        _isInitializing = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  设置单例
 */
+ (PTSProgressHUD *)shareView {
    static dispatch_once_t onceToken;
    static PTSProgressHUD *shareView;
    
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&onceToken, ^{
        shareView = [[self alloc] initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
    });
#else
    dispatch_once(&onceToken, ^{
        shareView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
#endif
    
    return shareView;
}

#pragma mark - Show/Hide
+ (void)show
{
    [self showWithGifImagePath:@"PTSProgressHUD.bundle/default.gif" withTitle:nil];
}

+ (void)showWithGifImagePath:(NSString *)imagePath withTitle:(NSString *)title
{
    [[self shareView] showProgressWithImagePath:imagePath title:title];
}

+ (void)showToView:(UIView *)toView
{
    [self showWithGifImagePath:@"PTSProgressHUD.bundle/default.gif" withTitle:nil toView:toView];
}

+ (void)showWithGifImagePath:(NSString *)imagePath withTitle:(NSString *)title toView:(UIView *)toView
{
    if (toView) {
        [self setToView:toView];
    }
    
    [[self shareView] showProgressWithImagePath:imagePath title:title];
}

+ (void)hide
{
    if ([self isVisible]) {
        [[self shareView] dismiss];
    }
}

#pragma mark - SET/GET
- (void)setGifImage:(UIImage *)gifImage
{
    if (!_isInitializing) {
        _gifImage = gifImage;
    }
}
- (void)setTitleStr:(NSString *)titleStr
{
    if (!_isInitializing) {
        _titleStr = titleStr;
    }
}
- (void)setTitleColor:(UIColor *)titleColor
{
    if (!_isInitializing) {
        _titleColor = titleColor;
    }
}
- (void)setTitleSize:(UIFont *)titleSize
{
    if (!_isInitializing) {
        _titleSize = titleSize;
    }
}
- (void)setTitleMargin:(CGFloat)titleMargin
{
    if (!_isInitializing) {
        _titleMargin = titleMargin;
    }
}
- (void)setGifImgRatio:(CGFloat)gifImgRatio
{
    if (!_isInitializing) {
        _gifImgRatio = gifImgRatio;
    }
}
- (void)setBgColor:(UIColor *)bgColor
{
    if (!_isInitializing) {
        _bgColor = bgColor;
    }
}
- (void)setViewForExtension:(UIView *)viewForExtension
{
    if (!_isInitializing) {
        _viewForExtension = viewForExtension;
    }
}
- (void)setToView:(UIView *)toView
{
    if (!_isInitializing) {
        _toView = toView;
    }
}

- (UIControl *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] init];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        _overlayView.backgroundColor = self.bgColor;
        [_overlayView addTarget:self action:@selector(didReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.translatesAutoresizingMaskIntoConstraints = NO;
        _hudView.backgroundColor = [UIColor clearColor];
        
    }
    
    if (!_hudView.superview) {
        [self.overlayView addSubview:_hudView];
        [self.overlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hudView]-0-|" options:0 metrics:nil views:@{@"hudView": _hudView}]];
        [self.overlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hudView]-0-|" options:0 metrics:nil views:@{@"hudView": _hudView}]];
    }
    
    return _hudView;
}
- (YYAnimatedImageView *)gifImageView
{
    if (!_gifImageView) {
        _gifImageView = [[YYAnimatedImageView alloc] init];
        _gifImageView.currentAnimatedImageIndex = 5;
        _gifImageView.translatesAutoresizingMaskIntoConstraints = NO;
        if (!_gifImageView.superview) {
            [self.hudView addSubview:_gifImageView];
            self.gitImageCenterX = [NSLayoutConstraint constraintWithItem:_gifImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0];
            self.gitImageCenterY = [NSLayoutConstraint constraintWithItem:_gifImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0];
            [self.hudView addConstraint:self.gitImageCenterX];
            [self.hudView addConstraint:self.gitImageCenterY];
        }
    }
    return _gifImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = self.titleSize;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        if (!_titleLabel.superview) {
            [self.hudView addSubview:_titleLabel];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gifImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.gifImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:self.titleMargin]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
    }
    return _titleLabel;
}

#pragma mark - Public Method
+ (void)setGifImage:(UIImage *)gifImage
{
    [self shareView].gifImage = gifImage;
}
+ (void)setTitleStr:(NSString *)titleStr
{
    [self shareView].titleStr = titleStr;
}
+ (void)setTitleColor:(UIColor *)titleColor
{
    [self shareView].titleColor = titleColor;
}
+ (void)setTitleSize:(UIFont *)titleSize
{
    [self shareView].titleSize = titleSize;
}
+ (void)setTitleMargin:(CGFloat)titleMargin
{
    [self shareView].titleMargin = titleMargin;
}
+ (void)setGifImgRatio:(CGFloat)gifImgRatio
{
    [self shareView].gifImgRatio = MAX(-1, MIN(gifImgRatio, 1));
}
+ (void)setBgColor:(UIColor *)bgColor
{
    [self shareView].bgColor = bgColor;
}
+ (void)setviewForExtension:(UIView *)viewForExtension
{
    [self shareView].viewForExtension = viewForExtension;
}
+ (void)setToView:(UIView *)toView
{
    [self shareView].toView = toView;
}

#pragma mark - Private Method
- (void)showProgressWithImagePath:(NSString *)imagePath title:(NSString *)title
{
    // 监听通知
    [self addNotification];
    
    if (!self.overlayView.superview) { // 如果UIControl的父控件不存在
#if !defined(SV_APP_EXTENSIONS)
        
        // 如果指定的view存在
        if (self.toView) {
            [self.toView addSubview:self.overlayView];
            [self.toView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
            [self.toView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
        } else {
            NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
            for (UIWindow *window in frontToBackWindows) {
                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
                BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
                
                if(windowOnMainScreen && windowIsVisible && windowLevelNormal){
                    [window addSubview:self.overlayView];
                    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
                    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
                    break;
                }
            }
        }
        
        
#else
        if (self.viewForExtension) {
            [self.viewForExtension addSubView:self.overlayView];
            [self.viewForExtension addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
            [self.viewForExtension addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
        }
#endif
    } else { // 如果UIControl的父控件存在
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    // 如果view的父控件不存在
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    if (!self.hasLoadImg) {
        // 添加gif图片
        if (self.gifImage) {
            self.gifImageView.image = self.gifImage;
        } else {
            if (imagePath) {
                self.gifImageView.image = [YYImage imageNamed:imagePath];
            } else {
                self.gifImageView.image = [YYImage imageNamed:@"PTSProgressHUD.bundle/default.gif"];
            }
        }
        
        // 添加文字
        if (self.titleStr) {
            self.titleLabel.text = self.titleStr;
        } else {
            if (title) {
                self.titleLabel.text = title;
            }
        }
        
        // 调整图片和文字的位置
        [self updateImageAndTitleFrame];
        
        self.hasLoadImg = YES;
    }
    
    // 展示
    if (self.alpha != 1 || self.overlayView.alpha != 1) {
        // 发送通知
        NSDictionary *userInfo = [self notificationUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDWillShowAnimationNotificationn object:nil userInfo:userInfo];
        
        // 增加动画
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:100 initialSpringVelocity:100 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.hudView.transform = CGAffineTransformMakeScale(1, 1);
            self.overlayView.alpha = 1.0;
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidShowAnimationNotificationn object:nil userInfo:userInfo];
        }];
    }
    
    
    
}

- (void)didReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event
{
    // 点击了UIControl时发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidReceiveTouchEventNotification object:event];
    
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchLocation = [touch locationInView:self];
    
    // 点击了hubView发送通知
    if (CGRectContainsPoint(self.hudView.frame, touchLocation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidTouchDownInsideNotification object:event];
    }
}

- (void)updateImageAndTitleFrame
{
    // 获取图片的高度
    CGFloat gifImgH = self.gifImage.size.height;
    // 重新设置约束
    CGFloat newImageCenterY = -gifImgH * self.gifImgRatio;
    self.gitImageCenterY.constant = newImageCenterY;
    
    [self layoutIfNeeded];
}

+ (BOOL)isVisible{
    return ([self shareView].alpha == 1);
}

- (NSDictionary*)notificationUserInfo{
    return (self.titleLabel.text ? @{PTSProgressHUDStatusUserInfoKey : self.titleLabel.text} : nil);
}

- (void)dismiss
{
    // 发送即将隐藏通知
    NSDictionary *userInfo = [self notificationUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDWillDisappearNotification object:nil userInfo:userInfo];
    
    // 取消动画
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptions) (UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.hudView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0.0;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidDisappearNotificationn object:nil userInfo:userInfo];
    }];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchEvent) name:PTSProgressHUDDidReceiveTouchEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHubViewEvent) name:PTSProgressHUDDidTouchDownInsideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewWillShow) name:PTSProgressHUDWillShowAnimationNotificationn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewDidShow) name:PTSProgressHUDDidShowAnimationNotificationn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewWillHide) name:PTSProgressHUDWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewDidHide) name:PTSProgressHUDDidDisappearNotificationn object:nil];
}

- (void)didReceiveTouchEvent
{
    [self willSendStatusToDelegate:PTSProgressStatusClickUIControl];
}

- (void)didHubViewEvent
{
    [self willSendStatusToDelegate:PTSProgressStatusClickHudView];
}

- (void)hubViewWillShow
{
    [self willSendStatusToDelegate:PTSProgressStatusWillShowHudView];
}

- (void)hubViewDidShow
{
    [self willSendStatusToDelegate:PTSProgressStatusDidShowHudView];
}

- (void)hubViewWillHide
{
    [self willSendStatusToDelegate:PTSProgressStatusWillHideHudView];
}

- (void)hubViewDidHide
{
    [self willSendStatusToDelegate:PTSProgressStatusDidHideHudView];
}

- (void)willSendStatusToDelegate:(PTSProgressStatus)status
{
    if ([self.delegate respondsToSelector:@selector(PTSProgressHUDGetHudViewStatus:)]) {
        [self.delegate PTSProgressHUDGetHudViewStatus:status];
    }
    
    if (self.statusBlock) {
        self.statusBlock(status);
    }
}

@end
