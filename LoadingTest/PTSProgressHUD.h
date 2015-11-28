//
//  PTSProgressHUD.h
//  LoadingTest
//
//  Created by 黄杰 on 15/11/27.
//  Copyright © 2015年 黄杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYImage.h"

@interface PTSProgressHUD : UIView

// git图片
@property (strong, nonatomic, readonly) UIImage *gifImage UI_APPEARANCE_SELECTOR;
// 文字
@property (copy, nonatomic, readonly) NSString *titleStr UI_APPEARANCE_SELECTOR;
// 文字颜色
@property (strong, nonatomic, readonly) UIColor *titleColor UI_APPEARANCE_SELECTOR;
// 文字大小
@property (strong, nonatomic, readonly) UIFont *titleSize UI_APPEARANCE_SELECTOR;
// 文字和图片间隙(默认为10间距)
@property (assign, nonatomic, readonly) CGFloat titleMargin UI_APPEARANCE_SELECTOR;
// 图片高度比例(默认为0.2，取值在-1到1之间, 值越大图片向上高度越大，反之越小越往下)
@property (assign, nonatomic, readonly) CGFloat gifImgRatio UI_APPEARANCE_SELECTOR;
// 背景颜色
@property (strong, nonatomic, readonly) UIColor *bgColor UI_APPEARANCE_SELECTOR;
// extension的view
@property (strong, nonatomic) UIView *viewForExtension UI_APPEARANCE_SELECTOR;

/**
 *  设置gif图片
 */
+ (void)setGifImage:(UIImage *)gifImage;
/**
 *  设置文字
 */
+ (void)setTitleStr:(NSString *)titleStr;
/**
 *  设置文字颜色
 */
+ (void)setTitleColor:(UIColor *)titleColor;
/**
 *  设置文字大小
 */
+ (void)setTitleSize:(UIFont *)titleSize;
/**
 *  设置文字和图片间隙
 */
+ (void)setTitleMargin:(CGFloat)titleMargin;
/**
 *  设置图片高度比例
 */
+ (void)setGifImgRatio:(CGFloat)gifImgRatio;
/**
 *  设置背景颜色
 */
+ (void)setBgColor:(UIColor *)bgColor;
/**
 *  设置extension的view
 */
+ (void)setviewForExtension:(UIView *)viewForExtension;

/**
 *  开始加载(默认gif图片，没有文字)
 */
+ (void)show;

/**
 *  加载(带文字和图片)
 *
 *  @param imagePath gif图片路径
 *  @param title     文字
 */
+ (void)showWithGifImagePath:(NSString *)imagePath withTitle:(NSString *)title;

/**
 *  隐藏动画
 */
+ (void)hide;

@end
