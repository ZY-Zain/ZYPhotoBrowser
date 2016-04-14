//
//  ZYPhotoCollectionViewCell.h
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYPhotoItem;

@interface ZYPhotoCollectionViewCell : UICollectionViewCell

/**
 *  一个cell代表一张图片 index代表这是第几张图片
 */
@property(nonatomic,assign) NSUInteger index;

/**
 *  图片模型，包含大图 小图的url
 */
@property(nonatomic,strong) ZYPhotoItem *photoItem;

@end
