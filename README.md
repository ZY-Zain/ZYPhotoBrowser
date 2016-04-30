 ZYPhotoBrowser
相册浏览器,10句代码即可完成接入   
支持GIF 暂时只支持网络图片  提供一个URL 即可自动完成所有操作。 布局自动根据屏幕大小进行布局  支持横屏浏览

整个模块以View控件来完成  所以只需要在你展示的地方 addSubview 即可  无需管理控制器，方便简洁

以后会陆续支持 本地图片  图片详情信息等



Photo browser, 10 other code can complete access
Support GIF temporarily only support network images provide a URL can automatically complete all operations.Layout of automatic layout on the screen size Support for landscape view

To complete the whole module with the View controls So you just need to addSubview where you show Without management controller, convenient and concise

Can support local image details information such as images in succession later



报错解决：
如果拖入此框架后  出现  error: linker command failed with exit code 1 (use -v to see invocation)  这种报错  只是第三方框架重复导入 而造成的编译错误。  因为此photoBrowser使用了 Masonry和SDWebImage 这两个框架，所以我的框架包里面也包含了这两个第三方 刚好你程序中也自己拖入了这两个框架，此时就会重复导入，造成编译错误，仅需随便删除多了的三方框架即可，可以删除这个photoBrowser里面的这两个第三方，也可以删除自己程序中的那个。总之，整个程序中只能拖入一个Masonry和SDWebImage，已经拖入了的程序 就不需要再拖入photoBrowser里面的Masonry和SDWebImage.
而作者近段时间内没太多空余时间去将这两个框架抽取分离出来，所以暂时提供了这么一个愚蠢的方案来供大家使用。

Error:
If appear   error: linker command failed with exit code 1 (use -v to see invocation)    this kind of error Just repeat import third-party frameworks The compiler error caused.Because the photoBrowser with Masonry and SDWebImage the two frameworks, so I am inside the package also includes the framework of the two third party you just also himself into the two frameworks in the program, will repeat the import at this time, cause a compiler error, only need to delete the tripartite framework, can remove the photoBrowser inside the two third party, the can also delete their program.In a word, the whole program can only be dragged into a Masonry and SDWebImage, already into the program Don't need to be dragged into photoBrowser Masonry and SDWebImage inside.
And the author in recent period of time not too much free time to go to isolate the two frameworks extraction, so temporary provides such a stupid plan for use by the people.


快速接入/ Quick access

``` 
 
//展示控件

ZYPhotoCollectionView *photoView = [[ZYPhotoCollectionView alloc] init];
    
//图片数组模型

NSMutableArray *photoItems = [NSMutableArray array];
    
//便利图片url数组 取出图片url 转换成模型 (图片url数据以字典形式提供过来)

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


小图总览
<p align="left">

	<img src="./photo/1.png" width=44%">

</p>



大图竖屏显示
<p align="left">

	<img src="./photo/2.png" width=44%">

</p>



大图竖屏显示
<p align="left">

	<img src="./photo/3.png" width=44%">

</p>



长图大图竖屏显示
<p align="left">

	<img src="./photo/9.png" width=44%">

</p>



GIF大图竖屏显示
<p align="left">

	<img src="./photo/4.png" width=44%">

</p>



GIF大图横屏显示
<p align="left">

	<img src="./photo/5.png" width=44%">

</p>



长图大图横屏显示
<p align="left">

	<img src="./photo/6.png" width=44%">

</p>



长图大图横屏放大显示
<p align="left">

	<img src="./photo/7.png" width=44%">

</p>




