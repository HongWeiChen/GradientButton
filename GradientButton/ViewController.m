//
//  ViewController.m
//  GradientButton
//
//  Created by Mars on 2019/2/27.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Gradient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColors:@[ [UIColor yellowColor], [UIColor redColor] ] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1.0) cornerRadius:4 forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(20, 100, 100, 100);
}


@end
