//
//  ViewController.m
//  Calculator
//
//  Created by cdel_GL on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalculatorView *calView = [CalculatorView calculator];
    calView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -285, [UIScreen mainScreen].bounds.size.width, 285);
    [self.view addSubview:calView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
