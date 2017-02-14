//
//  ViewController.m
//  ZYPhotoBrowserDemo
//
//  Created by ZhiYong_Huang on 16/4/14.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import "ViewController.h"
#import "ZYPhoto.h"

@interface ViewController ()
@property(nonatomic, strong) NSMutableArray <ZYPhotoModel *> *photoModelArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     注意！如果是利用约束来布局界面的  ZYPhotoCollectionView的创建方法initWithFrame也需要传入宽度width并且是正确的宽度。因为图片的布局都是依赖这个width来进行布局的。  然后在这里约束ZYPhotoCollectionView的顶部距离，左边距离和宽度。而高度则在ZYPhotoCollectionView里面进行约束。  已经在ZYPhotoCollectionView.m文件中该约束的地方 写好注释了，进去查看即可。

     English:
     Be careful！ If initWithFrame is used to create the layout of the interface, the ZYPhotoCollectionView method also requires an incoming width width and is the correct width. Because the layout of the picture is dependent on the layout of the width. And then here to constrain the top distance of ZYPhotoCollectionView, the left distance and width. The height of the ZYPhotoCollectionView inside the constraint. Has been written in the ZYPhotoCollectionView.m file where the constraints of the notes, go in to see.
     */

    //创建图片展示控件
    //English:Create pictures show control
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //注意 这里的width一定需要传值，后续的界面布局 都是依赖这个width进行计算布局
    //Engilsh:Pay attention to the width must be required value here, subsequent interface layout Is dependent on the width calculation and layout
    ZYPhotoCollectionView *photoView = [[ZYPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 300)];
    [self.view addSubview:photoView];

    self.photoModelArr  = [NSMutableArray array];
    //创建每一张图片模型 smallImageURL是该图片的缩略图(小图)URL  bigImageURL是该图片放大至全屏时展示的大图URL
    //English:Model smallImageURL every picture is the image thumbnails (inset) URL bigImageURL is the zoom to full screen display a larger image of a URL
    ZYPhotoModel *photoModel1 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg" bigImageURL:@"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg"];
    ZYPhotoModel *photoModel2 = [[ZYPhotoModel alloc] init];
    photoModel2.smallImageURL = @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg";
    photoModel2.bigImageURL = @"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg";
    //将所有创建好的图片模型图片 都放进数组中
    //English:Will all create a good image model in the array
    [self.photoModelArr addObjectsFromArray:@[photoModel1, photoModel2]];
    //调用方法 继续创建其他7张图片模型
    //English:A method is called Continue to create other 7 image model
    [self setupPhotoModel];

    //将创建好的图片模型数组 赋值给图片展示控件ZYPhotoCollectionView 然后就会自动根据图片属性进行布局
    //English:Will create a good image array model assigned to display controls ZYPhotoCollectionView then automatically according to the attributes of the image layout
    photoView.photoModelArray = self.photoModelArr.copy;
}

-(void)setupPhotoModel {
    ZYPhotoModel *photoModel3 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif" bigImageURL:@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"];
    ZYPhotoModel *photoModel4 = [[ZYPhotoModel alloc] init];
    photoModel4.smallImageURL = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
    photoModel4.bigImageURL = @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
    ZYPhotoModel *photoModel5 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg" bigImageURL:@"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg"];
    ZYPhotoModel *photoModel6 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg" bigImageURL:@"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg"];
    ZYPhotoModel *photoModel7 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg" bigImageURL:@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    ZYPhotoModel *photoModel8 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg" bigImageURL:@"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg"];
    ZYPhotoModel *photomodel9 = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg" bigImageURL:@"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"];
    [self.photoModelArr addObjectsFromArray:@[photoModel3, photoModel4, photoModel5, photoModel6, photoModel7, photoModel8, photomodel9]];
}

@end
