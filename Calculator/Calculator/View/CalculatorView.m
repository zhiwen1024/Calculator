//
//  CalculatorView.m
//  CdelQuestions
//
//  Created by cdel_GL on 15/8/26.
//  Copyright (c) 2015年 Gao Fusheng. All rights reserved.
//

#import "CalculatorView.h"
#import "UIView+frame.h"
@interface CalculatorView()
@property (weak, nonatomic) IBOutlet UILabel *resultLbel;
/**存储用户输入*/
@property (nonatomic,copy)NSMutableString *strM;
/**存储运算符*/
@property (nonatomic,strong)NSMutableArray *arrM;
/**是否显示结果*/
@property (nonatomic,assign)BOOL isShow;
/**存储器*/
@property (nonatomic,copy)NSString *saveStr;
@end



@implementation CalculatorView
#pragma mark 初始化
+ (instancetype)calculator
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CalculatorView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.userInteractionEnabled = YES;
}

#pragma mark 懒加载

- (NSMutableArray *)arrM
{
    if (_arrM == nil) {
        _arrM = [NSMutableArray array];
    }
    return _arrM;
}
- (NSMutableString *)strM
{
    if (_strM == nil) {
        _strM = [NSMutableString string];
    }
    return _strM;
}

#pragma mark功能实现
/**
 *  关闭按钮
 */
- (IBAction)closeBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}

//数字与运算符显示
- (IBAction)btnClick:(UIButton *)sender {
    if (self.isShow) {
        self.strM = nil;
        self.isShow = NO;
    }
    [self.strM appendString:sender.currentTitle];
    if ([self.strM containsString:@"C"]) {
        self.resultLbel.text = @"0";
        self.strM = nil;
        self.arrM = nil;
        return;
    }
    
    self.resultLbel.text = self.strM;
}
//计算
- (IBAction)calcuate:(UIButton *)sender {
    [self.arrM addObject:sender.currentTitle];
    
    if (self.arrM.count >1) {
        NSString *symbol = self.arrM.firstObject;
        NSArray *tempArr = [self.strM componentsSeparatedByString:symbol];
        NSString *str1 = tempArr.firstObject;
        NSString *str2 = tempArr.lastObject;
        self.resultLbel.text = [self culculate:symbol oneNum:str1 otherNum:str2];
        self.strM = nil;
        self.arrM = nil;
        [self.strM appendString:self.resultLbel.text];
        if (![sender.currentTitle isEqualToString:@"="]) {
            [self.arrM addObject:sender.currentTitle];
            [self.strM appendString:sender.currentTitle];
            self.isShow = NO;
        }else{
            self.isShow = YES;
        }
    }else{
        NSString *symbol = self.arrM.firstObject;
        if ([symbol isEqualToString:@"="]) {
            self.arrM = nil;
            self.resultLbel.text = self.strM;
            self.isShow = YES;
        }else{        
            [self.strM appendString:sender.currentTitle];
            self.resultLbel.text = self.strM;
            self.isShow = NO;
        }
    }
}

//开根号
- (IBAction)squrtcClick:(UIButton *)sender {
    float num = sqrtf([self.strM floatValue]);
    self.resultLbel.text = [NSString stringWithFormat:@"%.02f",num];
    self.strM = nil;
    [self.strM appendString:self.resultLbel.text];
    self.isShow = YES;
}
//删除一个数字
- (IBAction)delateOne:(UIButton *)sender {
    if (self.strM.length) {
        NSRange range = NSMakeRange(self.strM.length-1, 1);
        [self.strM deleteCharactersInRange:range];
        self.resultLbel.text = self.strM.length?self.strM:@"0";
    }
}
//功能点击
- (IBAction)functionClick:(UIButton *)sender {
    NSString *str = sender.currentTitle;
    if ([str isEqualToString:@"MC"]) {//删除存储器的内容
        self.saveStr = nil;
        
    }else if ([str isEqualToString:@"MR"]){//读出“寄数器”内的数据到窗口
        if (self.saveStr) {
          self.resultLbel.text = self.saveStr;
          self.strM = nil;
          [self.strM appendString:self.resultLbel.text];
        }
    }else if ([str isEqualToString:@"MS"]){//将当前窗口数据写入“寄数器
        self.saveStr = self.resultLbel.text;
        
    }else{//M+是将当前窗口数据与“寄数器”内的数据相加后再存入“寄数器”
        if (self.saveStr && self.resultLbel.text) {
            float tempNum1 = [self.saveStr floatValue];
            float tempNum2 = [self.resultLbel.text floatValue];
            self.saveStr = [NSString stringWithFormat:@"%.02f",tempNum1 + tempNum2 ] ;
        }
    }
}

#pragma mark 私有方法
//私有方法（字符串计算）
- (NSString *)culculate:(NSString *)str oneNum:(NSString *)oneNum otherNum:(NSString *)otherNum
{
    float one = [oneNum intValue] ;
    float two = [otherNum intValue];
    if ([oneNum containsString:@"."]) {
        one = [oneNum floatValue];
    }
    if ([otherNum containsString:@"."]) {
        two = [otherNum floatValue];
    }
    if (one ==0 && two == 0) {
        self.arrM = nil;
        return @"0";
    }
    if ([str isEqualToString:@"+"]) {
        return [NSString stringWithFormat:@"%.02f",one+two];
    }else if ([str isEqualToString:@"-"]){
        return [NSString stringWithFormat:@"%.02f",one-two];
    }else if ([str isEqualToString:@"×"]){
        return [NSString stringWithFormat:@"%.02f",one*two];
    }else if ([str isEqualToString:@"÷"]){
        return [NSString stringWithFormat:@"%.02f",one/two];
    }else{
        return @"0";
    }
}

@end
