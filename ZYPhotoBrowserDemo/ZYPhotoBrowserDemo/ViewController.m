//
//  ViewController.m
//  ZYPhotoBrowserDemo
//
//  Created by ZhiYong_Huang on 16/4/14.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import "ViewController.h"
#import "ZYPhotoCollectionView.h"
#import "ZYPhotoItem.h"
#import "SDWebImageManager.h"

@interface ViewController ()
/**
 *  所有图片url数组，每一个字典里面保存着一张图片对应的大图和小图的url
 */
@property(nonatomic,strong) NSArray<NSDictionary *> *photoURLs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //展示控件
    ZYPhotoCollectionView *photoView = [[ZYPhotoCollectionView alloc] init];
    //图片模型数组
    NSMutableArray *photoItems = [NSMutableArray array];
    
    //便利url数组 取出图片url 转换成模型
    [self.photoURLs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYPhotoItem *photoItem = [[ZYPhotoItem alloc] init];
        photoItem.smallImageURL = obj[@"smallImageURL"];
        photoItem.bigImageURL = obj[@"bigImageURL"];
        [photoItems addObject:photoItem];
    }];
    
    photoView.frame = self.view.bounds;
    [self.view addSubview:photoView];
    
    //给图片模型给展示控件 自动进行展示
    photoView.photoItemArray = photoItems.copy;
}

/**
 *  清空图片本地缓存
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        NSLog(@"清空图片缓存完成");
    }];
}

-(NSArray<NSDictionary *> *)photoURLs {
    if (!_photoURLs) {
        _photoURLs = @[
                       @{
                           @"smallImageURL" : @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                           @"bigImageURL" : @"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                           @"bigImageURL" : @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"
                           },
                       @{
                           @"smallImageURL" : @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                           @"bigImageURL" : @"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                           @"bigImageURL" : @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                           @"bigImageURL" : @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                           @"bigImageURL" : @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                           @"bigImageURL" : @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpgg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                           @"bigImageURL" : @"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg"
                           },
                       @{
                           @"smallImageURL" : @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
                           @"bigImageURL" : @"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                           }
                       ];
    }
    return _photoURLs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
