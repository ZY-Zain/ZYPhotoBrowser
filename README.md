# 智勇第三方 ZYPhotoBrowser 相册浏览器 

## 简介

5句代码 即可完成此第三方的接入。<br>
支持GIF 暂时只支持网络图片  提供一组URL 即可自动完成所有操作。<br> 
支持长按保存图片到相册,支持横屏查看图片，查看长图。点击图片时的放大、缩小都做了动画效果。<br>
布局自动根据屏幕大小进行布局  支持横屏浏览<br>
整个模块以CollectionView控件来完成 只需要在你展示的地方 addSubview 即可  无需管理控制器，方便简洁<br>
公开了一个config.h配置头文件，很多可以修改的样式、数据都可以直接在这里修改，无需深入代码来做修改。<br>
以后会陆续支持 本地图片 图片详情信息等<br>
<br>
## Introduction:

5 code to complete the access of the third party.<br>
Support GIF temporarily only support the network image to provide a set of URL can automatically complete all operations.<br> 
Support the long press to save the image to the album, support the horizontal screen view pictures, view long. Click on the image to zoom in and out to do animation. <br>
Layout automatically according to the size of the screen layout support horizontal screen browsing. <br>
The entire module in order to complete the CollectionView control only need to show where you can not need to manage the addSubview controller, convenient and simple.<br>
Open a config.h configuration header file, a lot of styles can be modified, the data can be directly modified here, no need to go deep into the code to make changes.<br>
Will continue to support local image details, such as. <br>
<br>
<br>

## 注意事项：

因为此项目中需要使用到一些另外的第三方，分别是"Masonry"、"SDWebImage"、"MBProgressHUD"。这里我也将这些第三方放入了Demo文件夹中的Libary文件夹中。<br>
如果你原有的程序中，并没有使用到这些第三方，那么只需要连同Libary文件夹一起拖入程序中即可。如果你原有的程序中使用了这些第三方，那么就无需拖动这些第三方进程序中，只需拖入ZYPhotoBrowser文件夹即可。<br>
<br>
## Matters needing attention:
Because this project needs to be used to some other third parties, namely "Masonry", "SDWebImage", "MBProgressHUD". Here I also put these third parties into the Demo folder in the Libary folder. <br>
If your original program, and did not use these third party, then you only need Libary folder into the program together with you. If these third parties use your original program, then there is no need to drag the third party into the program, just into the ZYPhotoBrowser folder.<br>
<br>
<br>
<br>
如果感觉对你有帮助，记得点一下星，你的点星是我更新更多第三方的动力。谢谢!
<br>
If it feels good for you, remember to click on the stars, and your star is my power to update more third parties. Thank you!
<br>
<br>
<br>
## 快速接入/Quick access


```Objective-C
//引入头文件
//Includes Header file
#import "ZYPhoto.h"
//创建图片展示控件collectionView
//English:Create picture display control collectionView
ZYPhotoCollectionView *photoView = [[ZYPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 0, 414, 300)];
[self.view addSubview:photoView];

//创建每一张图片模型 smallImageURL是该图片的缩略图(小图)URL  bigImageURL是该图片放大至全屏时展示的大图URL
//English:Create each image model smallImageURL is a thumbnail of the image (thumbnail) URL bigImageURL is the image enlarged to full screen display of the big picture URL
ZYPhotoModel *photoModel = [[ZYPhotoModel alloc] initWithsmallImageURL:@"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg" bigImageURL:@"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg"];
//将创建好的图片模型传入一个数组中  如果有多张图片 都统一放进数组中即可
//English:Will create a good image model into an array if there are multiple images are unified into the array can be
NSArray <ZYPhotoModel *> *photoModelArr = @[photoModel];

//将创建好的图片模型数组 赋值给图片展示控件ZYPhotoCollectionView 然后就会自动根据图片数量进行布局
//English:Will create a good image model array assigned to the picture display control ZYPhotoCollectionView and then automatically according to the number of images for layout
photoView.photoModelArray = photoModelArr;
```

##### 详细展示
![img](http://wx1.sinaimg.cn/mw690/7ef5f86agy1fcpzoeksb1g205k0a0e81.gif "详细展示")

##### 横屏展示
![img](http://wx4.sinaimg.cn/mw690/7ef5f86agy1fcpztaroj3g20ag0a0u0x.gif "横屏展示")

##### 保存图片时的展示
![img](http://wx3.sinaimg.cn/mw690/7ef5f86agy1fcpzwj3zw4g205k0a01kx.gif "保存图片展示")

##### 4张图片时的布局展示
![img](http://wx4.sinaimg.cn/mw690/7ef5f86agy1fcpy2qfi5jj20yi1pce17.jpg "4张图片的布局")

##### 单张图片时的布局展示
![img](http://wx2.sinaimg.cn/mw690/7ef5f86agy1fcpy2vbtajj20yi1pc7wh.jpg "单张图片的布局")

##### config配置文件展示
![img](http://wx4.sinaimg.cn/mw690/7ef5f86agy1fcpy2sr9cqj20uw0lftfw.jpg "config配置文件")




