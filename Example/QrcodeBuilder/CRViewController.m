//
//  CRViewController.m
//  QrcodeBuilder
//
//  Created by corotata on 07/13/2017.
//  Copyright (c) 2017 corotata. All rights reserved.
//

#import "CRViewController.h"
#import <QrcodeBuilder/QrcodeBuilder.h>
@interface CRViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)createTextQRCodeClick:(UIButton *)sender {
    
    self.imageView.image = [UIImage coro_createQRCodeWithText:@"hi,corotata" size:200];
    
}

- (IBAction)createTextQRCodeWithImageClick:(UIButton *)sender {
    self.imageView.image = [UIImage coro_createQRCodeWithText:@"hi,corotata" size:200 centerImage:[UIImage imageNamed:@"panda.jpg"]];
}


- (IBAction)createTextQRCodeClickAndCustomColor:(UIButton *)sender {
    
    self.imageView.image = [UIImage coro_createQRCodeWithText:@"hi,corotata" size:200 AndTransformColorWithRed:(arc4random() % 256) andGreen:(arc4random() % 256) andBlue:(arc4random() % 256)];
}


- (IBAction)createTextQRCodeWithImageAndCustomColorClick:(UIButton *)sender {
    self.imageView.image = [UIImage coro_createQRCodeWithText:@"hi,corotata" size:200 centerImage:[UIImage imageNamed:@"panda.jpg"] AndTransformColorWithRed:(arc4random() % 256) andGreen:(arc4random() % 256) andBlue:(arc4random() % 256)];
}




@end
