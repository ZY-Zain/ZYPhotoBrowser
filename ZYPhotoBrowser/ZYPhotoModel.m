//
//  ZYPhotoModel.m
//  ZYPhotoBrowserDemo
//
//  Created by ZhiYong_Huang on 2017/2/13.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import "ZYPhotoModel.h"

@implementation ZYPhotoModel
-(instancetype)initWithsmallImageURL:(NSString *)smallImageURL bigImageURL:(NSString *)bigImageURL {
    if (self = [super init]) {
        self.smallImageURL = smallImageURL;
        self.bigImageURL = bigImageURL;
    }
    return self;
}
@end
