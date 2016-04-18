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

@property(nonatomic,assign) NSUInteger index;
@property(nonatomic,strong) ZYPhotoItem *photoItem;

@end
