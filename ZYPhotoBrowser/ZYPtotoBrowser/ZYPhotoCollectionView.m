//
//  ZYPhotoCollectionView.m
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import "ZYPhotoCollectionView.h"
#import "ZYPhotoBrowserConfig.h"
//展示
#import "ZYPhotoCollectionViewCell.h"
#import "ZYPhotoBrowser.h"
//图片模型
#import "ZYPhotoItem.h"
//第三方
#import "Masonry.h"
#import "SDImageCache.h"

@interface ZYPhotoCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, HZPhotoBrowserDelegate>
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@end

@implementation ZYPhotoCollectionView

-(instancetype)init {
    //预估的frame  后期取得数据后 通过约束来纠正
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:self.layout]) {
        [self registerClass:[ZYPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ZYPhotoCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = ZYSmallPhotoBackgrounColor;
    }
    return self;
}

#pragma mark - 布局 小图时展示图片控件的大小
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    //约束
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//    }];
//}

//计算约束尺寸
-(void)getLayoutSize {
    long imageCount = self.photoItemArray.count;
    
    imageCount = imageCount > ZYPhotoMaxCount ? ZYPhotoMaxCount : imageCount;
    
    //求出列数
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
//        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    //求出行数
    int totalRowCount = ((int)(imageCount + perRowImageCount - 1) / perRowImageCount); // ((imageCount + perRowImageCount - 1) / perRowImageCount)  公式等同于: ceil(imageCount / perRowImageCountF)
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    int w;
    int h;
    
    if (imageCount == 0) {
        w = 0.0;
    } else if (imageCount == 1) {
        //一张图片的时候 图片的size为 屏幕宽度-两边距后 的一半
        w = (screenWidth - ZYPhotoGroupImageMargin * 2) * 0.5;
    } else if (imageCount == 2) {
        //两张图片的时候 图片的size为 屏幕宽度-两边距后再减去两张图片之间的边距 的一半
        w = (screenWidth - ZYPhotoGroupImageMargin * 3) *0.5;
    } else {
        w = (screenWidth - ZYPhotoGroupImageMargin * 4) /3;
    }
    h = w;
    
    self.layout.itemSize = CGSizeMake(w, h);
    self.layout.minimumLineSpacing = ZYPhotoGroupImageMargin;
    self.layout.minimumInteritemSpacing = ZYPhotoGroupImageMargin;
    
    //根据图片的数量动态计算高度
    CGFloat height = ZYPhotoEdgeInsets + totalRowCount * (ZYPhotoGroupImageMargin + h);
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(ZYPhotoEdgeInsets);
        make.right.mas_equalTo(-ZYPhotoEdgeInsets);
        //因为上面计算高度的公式已经将底部的间距给算了进去 所以这里约束的时候无需再增加一个间距的高度
        make.height.mas_equalTo(height);
    }];
    
    [self reloadData];
}

#pragma mark - collection 代理 & 数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //取得的数据大于9张图片 默认显示前面9张
    return self.photoItemArray.count > ZYPhotoMaxCount ? ZYPhotoMaxCount : self.photoItemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZYPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.index = indexPath.item;
    cell.photoItem = self.photoItemArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self buttonClick:indexPath];
}

- (void)buttonClick:(NSIndexPath *)indexPath
{
    //启动图片浏览器
    ZYPhotoBrowser *browser = [[ZYPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count > ZYPhotoMaxCount ? ZYPhotoMaxCount : self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = (int)indexPath.item;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(ZYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //取出点击的图片模型的小图url
    NSString *smallImageURL = [self.photoItemArray[index] smallImageURL];
    //根据url 取出缓存中的图片
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL];
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(ZYPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.photoItemArray[index] bigImageURL];
    
    return [NSURL URLWithString:urlStr];
}

#pragma mark - 懒加载
-(void)setPhotoItemArray:(NSArray *)photoItemArray {
    _photoItemArray = photoItemArray;
    //得到数据后 进行布局
    [self getLayoutSize];
}

-(UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

@end
