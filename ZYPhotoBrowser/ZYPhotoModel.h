//
//  ZYPhotoModel.h
//  ZYPhotoBrowserDemo
//
//  Created by ZhiYong_Huang on 2017/2/13.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    一个ZYPhotoModel模型 对应一张图片

    English:A ZYPhotoModel model correspond to a picture
 */
@interface ZYPhotoModel : NSObject
/**
 *  缩略图的图片url
    
    English:Thumbnail images of the url
 */
@property (nonatomic, copy) NSString *smallImageURL;
/**
 *  大图的图片url
 
    Engilsh:A larger image url
 */
@property (nonatomic, copy) NSString *bigImageURL;
/**
 *  快速创建图片模型
 
    Engilsh:To quickly create images model
 *
 *  @param smallImageURL 缩略图的url  smallImageURL
 *  @param bigImageURL   大图的url    bigImageURL
 *
 *  @return 返回图片模型  Engilsh:Return to picture model
 */
-(instancetype)initWithsmallImageURL:(NSString *)smallImageURL bigImageURL:(NSString *)bigImageURL;
@end
