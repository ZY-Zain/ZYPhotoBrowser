 ZYPhotoBrowser
相册浏览器,10句代码即可完成接入   
支持GIF 暂时只支持网络图片  提供一个URL 即可自动完成所有操作。 布局自动根据屏幕大小进行布局  支持横屏浏览

整个模块以View控件来完成  所以只需要在你展示的地方 addSubview 即可  无需管理控制器，方便简洁

以后会陆续支持 本地图片  图片详情信息等



Photo browser, 10 other code can complete access
Support GIF temporarily only support network images provide a URL can automatically complete all operations.Layout of automatic layout on the screen size Support for landscape view

To complete the whole module with the View controls So you just need to addSubview where you show Without management controller, convenient and concise

Can support local image details information such as images in succession later








快速接入/ Quick access

``` 
 
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
```


![小图总览](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/1.png)

![大图竖屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/2.png)

![大图竖屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/3.png)

![GIF大图竖屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/4.png)

![GIF大图横屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/5.png)

![长图大图横屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/6.png)

![长图大图横屏放大显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/7.png)

![长图大图竖屏显示](http://github.com/ZhiYongHuangOne/ZYPhotoBrowser/raw/master/photo/8.png)

