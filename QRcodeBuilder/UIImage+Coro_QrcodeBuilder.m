//
//  UIImage+Coro_QrcodeBuilder.m
//  QRcodeBuilder
//
//  Created by Corotata on 15/11/27.
//  Copyright © 2015年 corotata. All rights reserved.
//

#import "UIImage+Coro_QrcodeBuilder.h"

@implementation UIImage (Coro_QrcodeBuilder)

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size {
    return [self coro_createQRCodeWithText:text size:size iconImage:nil];
}

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size iconImage:(UIImage *)iconImage {
    return [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:text] withSize:size WithCenterImage:iconImage];
    
}

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size AndTransformColorWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    return [self coro_createQRCodeWithText:text size:size iconImage:nil AndTransformColorWithRed:red andGreen:green andBlue:blue];

}

+ (UIImage *)coro_createQRCodeWithText:(NSString *)text size:(CGFloat)size iconImage:(UIImage *)iconImage AndTransformColorWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    UIImage *buildImage = [self coro_createQRCodeWithText:text size:size];
    buildImage = [buildImage imageBlackToTransparentWithRed:red andGreen:green andBlue:blue];
    if (iconImage) {
        buildImage = [buildImage coro_drawCenterImage:iconImage];
    }
    return buildImage;
}



+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size WithCenterImage:(UIImage *)centerImage {
    UIImage *bilderImage = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
    if (!centerImage) {
        return bilderImage;
    }
    UIGraphicsBeginImageContext(bilderImage.size);
    
    [bilderImage drawAtPoint:CGPointZero];
    
    CGFloat centerImageHW = size/3;
    CGFloat centerImageXY = (size - centerImageHW)/2;
    
    [centerImage drawInRect:CGRectMake(centerImageXY, centerImageXY, centerImageHW, centerImageHW)];
    bilderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return bilderImage;
}

- (UIImage *)coro_drawCenterImage:(UIImage *)centerImage {
    if (centerImage) {
        UIImage *buildImage = nil;

        UIGraphicsBeginImageContext(self.size);
        
        [self drawAtPoint:CGPointZero];
        
        CGFloat centerImageHW = self.size.width/3;
        CGFloat centerImageXY = (self.size.width - centerImageHW)/2;
        
        [centerImage drawInRect:CGRectMake(centerImageXY, centerImageXY, centerImageHW, centerImageHW)];
        buildImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return buildImage;
    }
    return self;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparentWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}




@end
