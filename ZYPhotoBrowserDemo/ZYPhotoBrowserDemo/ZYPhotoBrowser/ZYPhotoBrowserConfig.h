//
//  HZPhotoBrowserConfig.h
//  HZPhotoBrowser
//
//  Created by aier on 15-2-9.
//  Copyright (c) 2015年 GHZ. All rights reserved.
//


typedef enum {
    ZYWaitingViewModeLoopDiagram, // 原型空心   Prototype of the hollow
    ZYWaitingViewModePieDiagram // 原型实心   Prototype solid
} ZYWaitingViewMode;

typedef enum {
    ZYNumPageType,     //数字展示图片数量   Digital display graphics
    ZYPageControlType  //系统默认 分页条UIPageControl   The system default paging UIPageControl
} ZYPageTypeMode;

#define ZYMinZoomScale 0.6f
#define ZYMaxZoomScale 2.0f

#define ZYAPPWidth [UIScreen mainScreen].bounds.size.width
#define ZYAppHeight [UIScreen mainScreen].bounds.size.height

#define ZYIsFullWidthForLandScape NO //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES     Whether directly when landscape full width, rather than the full height, usually with long figure demand when set to YES

//是否支持横屏   Whether to support the landscape
#define ZYISShouldLandscape YES

//使用哪种样式显示 图片总数量与当前查看的图片    Use which kinds of style show Total quantity and the current view pictures
#define ZYPageType ZYPageControlType

//能展示最大多少张图片（如果实际图片数量大于此数量，默认显示前面的图片）    Can show the maximum image (if the actual quantity is greater than the number of images, the default display in front of the picture)
#define ZYPhotoMaxCount 9

//占位图   Placeholder figure
#define ZYPlaceholderImage [UIImage imageNamed:@"placeholderImage"]

//小图界面下 个张小图之间的间距    The distance between the interface of a small map of Zhang map
#define ZYPhotoGroupImageMargin 10

//小图界面下 整个展示图片的控件的四周内边距  Around the small map interface display of the entire picture controls padding
#define ZYPhotoEdgeInsets 10

// 图片保存成功提示文字   Save picture success Title
#define ZYPhotoBrowserSaveImageSuccessText @" 保存成功 ";

// 图片保存失败提示文字   Save picture error Title
#define ZYPhotoBrowserSaveImageFailText @" 保存失败 ";

//小图模式下 背景颜色  Background color in thumbnail mode
#define ZYSmallPhotoBackgrounColor [UIColor whiteColor]

// 照片浏览器的背景颜色  Background color for photo browser
#define ZYPhotoBrowserBackgrounColor [UIColor blackColor]

// 照片浏览器中 图片之间的margin    Margin between pictures in a photo browser
#define ZYPhotoBrowserImageViewMargin 10

// 照片浏览器中 屏幕旋转时 使用这个时间 来做动画修改图片的展示     Use this time to animate and modify the image in the photo browser
#define ZYAnimationDuration 0.35f

// 照片浏览器中 显示图片动画时长    The length of the picture animation in the photo browser
#define ZYPhotoBrowserShowImageAnimationDuration 0.35f

// 照片浏览器中 隐藏图片动画时长    Photo browser hide image animation long
#define ZYPhotoBrowserHideImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（ZYWaitingViewModeLoopDiagram 圆形空心，ZYWaitingViewModePieDiagram 圆形实心）    Download progress indicator
#define ZYWaitingViewProgressMode ZYWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色    Download progress indicator backgroundColor
#define ZYWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距    The distance between the internal controls of the download progress indicator
#define ZYWaitingViewItemMargin 10

