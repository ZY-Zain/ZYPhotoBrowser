//
//  ZYPhotoCollectionView.h
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYPhotoModel;
@interface ZYPhotoCollectionView : UICollectionView
/**
 *  传入图片模型数组 会自动根据数组的数量 来布局展示图片
 
    English:
    Introduced into image array model automatically according to the number of array layout display pictures
 */
@property (nonatomic, strong) NSArray <ZYPhotoModel *>*photoModelArray;
/**
 *  工厂方法 注意frame.size.widt一定需要有值 因为计算布局是依据这个width来进行布局 这里设置的height并不会起效 因为在内部会根据图片的数量 自适应修改高度

    English:
    The factory method pay attention to the frame. The size. Widt must need to have value Because calculation layout is based on the width for layout Here set the height will not work Because ministries, the number of adaptive change height according to the pictures
 *
 *  @param frame frame
 *
 *  @return 展示控件  English:Display control
 */
-(instancetype)initWithFrame:(CGRect)frame;
@end
