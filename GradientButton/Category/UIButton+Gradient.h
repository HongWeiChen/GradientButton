//
//  UIButton+Add.h
//  GradientButton
//
//  Created by Mars on 2019/2/27.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Gradient)

- (void)setBackgroundColors:(NSArray<UIColor *> *)backgroundColors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint forState:(UIControlState)state;

- (void)setBackgroundColors:(NSArray<UIColor *> *)backgroundColors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
