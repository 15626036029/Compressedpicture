


//
//  ResetSizeImage.m
//  Image
//
//  Created by goldeneye on 2017/4/24.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "ResetSizeImage.h"

@implementation ResetSizeImage

- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(int)maxSize{
    //先调整分辨率
    CGSize  newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth  = newSize.width / 1024;
    if (tempWidth>1.0 && tempWidth>tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight,source_image.size.height / tempHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawAsPatternInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //先判断当前质量是否满足要求，不满足再进行压缩
    NSData * finallImageData = UIImageJPEGRepresentation(newImage, 1.0);
    int sizeOriginKB = (int)finallImageData.length/1024;
    
    NSLog(@"1===sizeOriginKB===%i",sizeOriginKB);
    
    if (sizeOriginKB<=maxSize) {
        return finallImageData;
    }
    //保存压缩系数
    NSMutableArray * compressionQualityArr = [NSMutableArray array];
    CGFloat avg = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i>=1; i--) {
        value = i* avg;
        [compressionQualityArr addObject:@(value)];
    }
    //调整大小
    //说明：压缩系数数组compressionQualityArr是从大到小存储。
    //思路：折半计算，如果中间压缩系数仍然降不到目标值maxSize，则从后半部分开始寻找压缩系数；反之从前半部分寻找压缩系数
    finallImageData = UIImageJPEGRepresentation(newImage, [compressionQualityArr[125] floatValue]);
    if (finallImageData.length/1024>maxSize) {
        //拿到最初的大小
        finallImageData = UIImageJPEGRepresentation(newImage, 1.0);
        //从后半部分开始
        for (int i=126; i<250; i++) {
            
            int sizeOriginKB = (int)finallImageData.length/1024;
            NSLog(@"2===sizeOriginKB==%i",sizeOriginKB);
            if (sizeOriginKB>maxSize) {
                finallImageData = UIImageJPEGRepresentation(newImage, [compressionQualityArr[i] floatValue]);
            }else
            {
                break;
            }
        }
    }else{
        //拿到最初的大小
        finallImageData = UIImageJPEGRepresentation(newImage, 1.0);
        for (int i = 0; i <125; i++) {
            int sizeOriginKB = (int)finallImageData.length/1024;
            NSLog(@"3===sizeOriginKB==%i",sizeOriginKB);
            if (sizeOriginKB>maxSize) {
                finallImageData = UIImageJPEGRepresentation(newImage, [compressionQualityArr[i] floatValue]);
            }else
            {
                break;
            }
        }
    }
    return finallImageData;
    
}

- (NSData *)resetSizeOfImageDataMethodTwo:(UIImage *)source_image maxSize:(int)maxSize
{
    
    //先判断当前质量是否满足要求，不满足再进行压缩
    NSData * finallImageData = UIImageJPEGRepresentation(source_image, 1.0);
    int sizeOriginKB = (int)finallImageData.length/1024;
    
    NSLog(@"1===sizeOriginKB===%i",sizeOriginKB);
    
    if (sizeOriginKB<=maxSize) {
        return finallImageData;
    }
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024);
    UIImage *newImage = [self newSizeImage:defaultSize source_image:source_image];
    finallImageData = UIImageJPEGRepresentation(newImage, 1.0);
    //保存压缩系数
    NSMutableArray * compressionQualityArr = [NSMutableArray array];
    CGFloat avg = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i>=1; i--) {
        value = i* avg;
        [compressionQualityArr addObject:@(value)];
    }
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length==0) {
        //每次降100分辨率
        if (defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0){
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-100, defaultSize.height-100);
        UIImage * image = [self newSizeImage:defaultSize source_image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage, [compressionQualityArr.lastObject floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    int sizeOriginKB2 = (int)finallImageData.length/1024;
     NSLog(@"2===sizeOriginKB===%i",sizeOriginKB2);
    return finallImageData;
    
}

- (UIImage *)newSizeImage:(CGSize )size source_image:(UIImage *)source_image
{
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize =  CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
        
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight,  source_image.size.height / tempHeight)  ;
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// MARK: - 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(int)maxSize
{
    NSData * tempFinallImageData = finallImageData;
    NSData * tempData = [NSData new];
    int start = 0;
    int end = (int)arr.count-1;
    int index = 0;
    int difference = INT_MAX;
    while (start<=end) {
        index = start + (end - start)/2;
        tempFinallImageData = UIImageJPEGRepresentation(image, [arr[index] floatValue]);
        int sizeOrigin = (int)tempFinallImageData.length;
        int sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"sizeOriginKB====%i",sizeOriginKB);
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference){
                difference = maxSize-sizeOriginKB;
                tempData = tempFinallImageData;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return  tempData;
}
@end
