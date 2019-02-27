//
//  UIButton+Add.m
//  GradientButton
//
//  Created by Mars on 2019/2/27.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UIButton+Gradient.h"
#import <objc/runtime.h>

void *BTN_STYLE = "BUTTON_STYLE";

@implementation UIButton (Gradient)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method newMethod = class_getInstanceMethod(self, @selector(hook_layoutSubviews));
    if (!originalMethod || !newMethod) return;
    
    class_addMethod(self, @selector(layoutSubviews), class_getMethodImplementation(self, @selector(layoutSubviews)), method_getTypeEncoding(originalMethod));
    class_addMethod(self, @selector(hook_layoutSubviews), class_getMethodImplementation(self, @selector(hook_layoutSubviews)), method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(hook_layoutSubviews)));
}

- (void)hook_layoutSubviews {
    [self hook_layoutSubviews];
    
    NSDictionary *styles = [self styles];
    for (NSDictionary *dict in styles.allValues) {
        CGRect bounds = [[dict objectForKey:@"bounds"] CGRectValue];
        if (!CGRectEqualToRect(self.bounds, bounds)) {
            id color = [dict objectForKey:@"color"];
            CGPoint startPoint = [[dict objectForKey:@"start"] CGPointValue];
            CGPoint endPoint = [[dict objectForKey:@"end"] CGPointValue];
            CGFloat cornerRadius = [[dict objectForKey:@"corner"] floatValue];
            UIControlState state = [[dict objectForKey:@"state"] unsignedIntegerValue];
            [self setBackgroundColors:color startPoint:startPoint endPoint:endPoint cornerRadius:cornerRadius forState:state];
        }
    }
}

- (NSDictionary *)styles {
    return objc_getAssociatedObject(self, BTN_STYLE);
}

- (void)setBackgroundColors:(NSArray<UIColor *> *)backgroundColors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint forState:(UIControlState)state {
    [self setBackgroundColors:backgroundColors startPoint:startPoint endPoint:endPoint cornerRadius:0.0 forState:state];
}

- (void)setBackgroundColors:(NSArray<UIColor *> *)backgroundColors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:backgroundColors forKey:@"color"];
    [dictionary setObject:[NSValue valueWithCGPoint:startPoint] forKey:@"start"];
    [dictionary setObject:[NSValue valueWithCGPoint:endPoint] forKey:@"end"];
    [dictionary setObject:@(cornerRadius) forKey:@"corner"];
    [dictionary setObject:@(state) forKey:@"state"];
    [dictionary setObject:[NSValue valueWithCGRect:self.bounds] forKey:@"bounds"];
    NSMutableDictionary *styles = [[NSMutableDictionary alloc] initWithDictionary:[self styles]];
    [styles setObject:dictionary forKey:@(state)];
    objc_setAssociatedObject(self, BTN_STYLE, styles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (UIColor *color in backgroundColors) {
        if ([color isKindOfClass:UIColor.class]) {
            [colors addObject:(__bridge id)color.CGColor];
        } else {
            [colors addObject:color];
        }
    }
    //创建渐变Layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = colors;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    layer.frame = self.bounds;
    //Layer转换图片
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置为背景图片
    [self setBackgroundImage:snapshotImage forState:state];
}

@end
