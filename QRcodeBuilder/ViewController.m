//
//  ViewController.m
//  QRcodeBuilder
//
//  Created by Corotata on 15/11/27.
//  Copyright © 2015年 corotata. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Coro_QrcodeBuilder.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView1.image = [UIImage coro_createQRCodeWithText:@"hello" size:self.imageView1.frame.size.width];
    self.imageView2.image = [UIImage coro_createQRCodeWithText:@"My love!!!!!" size:self.imageView2.frame.size.width iconImage:[UIImage imageNamed:@"abc"]];
    self.imageView3.image = [UIImage coro_createQRCodeWithText:@"你是123456，are you really?" size:self.imageView3.frame.size.width AndTransformColorWithRed:110.0f andGreen:120.0f andBlue:87.0f];
    self.imageView4.image = [UIImage coro_createQRCodeWithText:@"有点无聊！" size:self.imageView4.frame.size.width iconImage:[UIImage imageNamed:@"abc"] AndTransformColorWithRed:1.0f andGreen:10.0f andBlue:124.0f];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
