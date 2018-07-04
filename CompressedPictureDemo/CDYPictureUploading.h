//
//  CDYPictureUploading.h
//  photoDemo
//
//  Created by 毛织网 on 2018/5/25.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Databack)(id data);
@interface CDYPictureUploading : NSObject
+ (NSString *)postimageWithURL: (NSString *)url  // IN
                      postParems: (NSDictionary *)postDic // IN 提交参数据集合
                     imagedata: (NSData *)imagedata  // IN 上传图片路径
                     picFileName: (NSString *)picFileName //服务器的接收数据参数名字
                     andCallback:(Databack)databack;;
@end
