//
//  ZYPhotoCollectionView.m
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import "ZYPhotoCollectionView.h"
#import "ZYPhotoBrowserConfig.h"
#import "ZYPhotoCollectionViewCell.h"
#import "ZYPhotoBrowser.h"
#import "ZYPhotoItem.h"
#import "Masonry.h"
#import "SDImageCache.h"

@interface ZYPhotoCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, HZPhotoBrowserDelegate>
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@end

@implementation ZYPhotoCollectionView

-(instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:self.layout]) {
        [self registerClass:[ZYPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ZYPhotoCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = ZYSmallPhotoBackgrounColor;
    }
    return self;
}

#pragma mark - 布局 小图时展示图片控件的大小
-(void)getLayoutSize {
    long imageCount = self.photoItemArray.count;
    
    imageCount = imageCount > ZYPhotoMaxCount ? ZYPhotoMaxCount : imageCount;
    
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);

    int totalRowCount = ((int)(imageCount + perRowImageCount - 1) / perRowImageCount);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenBounds.size.width;
    int w;
    int h;
    
    if (imageCount == 0) {
        w = 0.0;
    } else if (imageCount == 1) {
        w = (screenWidth - ZYPhotoGroupImageMargin * 2) * 0.5;
    } else if (imageCount == 2) {
        w = (screenWidth - ZYPhotoGroupImageMargin * 3) *0.5;
    } else {
        w = (screenWidth - ZYPhotoGroupImageMargin * 4) /3;
    }
    h = w;
    
    self.layout.itemSize = CGSizeMake(w, h);
    self.layout.minimumLineSpacing = ZYPhotoGroupImageMargin;
    self.layout.minimumInteritemSpacing = ZYPhotoGroupImageMargin;
    
    CGFloat height = ZYPhotoEdgeInsets + totalRowCount * (ZYPhotoGroupImageMargin + h);
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(ZYPhotoEdgeInsets);
        make.right.mas_equalTo(-ZYPhotoEdgeInsets);
        make.height.mas_equalTo(height);
    }];
    
    [self reloadData];
}

#pragma mark - collection Delegate & DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
    ZYPhotoBrowser *browser = [[ZYPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoItemArray.count > ZYPhotoMaxCount ? ZYPhotoMaxCount : self.photoItemArray.count;
    browser.currentImageIndex = (int)indexPath.item;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowserDelegate
- (UIImage *)photoBrowser:(ZYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSString *smallImageURL = [self.photoItemArray[index] smallImageURL];
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL];
}

- (NSURL *)photoBrowser:(ZYPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.photoItemArray[index] bigImageURL];
    
    return [NSURL URLWithString:urlStr];
}

#pragma mark - 懒加载
-(void)setPhotoItemArray:(NSArray *)photoItemArray {
    _photoItemArray = photoItemArray;
    [self getLayoutSize];
}

-(UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

@end
