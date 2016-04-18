//
//  ZYPhotoBrowserConfig.h
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

typedef enum {
    ZYWaitingViewModeLoopDiagram, // 原型空心
    ZYWaitingViewModePieDiagram // 原型实心
} ZYWaitingViewMode;

typedef enum {
    ZYNumPageType,     //数字展示图片数量
    ZYPageControlType  //系统默认 分页条UIPageControl
} ZYPageTypeMode;

#define ZYMinZoomScale 0.6f
#define ZYMaxZoomScale 2.0f

#define ZYAPPWidth [UIScreen mainScreen].bounds.size.width
#define ZYAppHeight [UIScreen mainScreen].bounds.size.height

#define ZYIsFullWidthForLandScape NO //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

//是否支持横屏
#define ZYISShouldLandscape YES

//使用哪种样式显示 图片总数量与当前查看的图片
#define ZYPageType ZYPageControlType

//能展示最大多少张图片（如果实际图片数量大于此数量，默认显示前面的图片）
#define ZYPhotoMaxCount 9

//占位图
#define ZYPlaceholderImage [UIImage imageNamed:@"placeholderImage"]

//小图界面下 个张小图之间的间距
#define ZYPhotoGroupImageMargin 10

//小图界面下 整个展示图片的控件的四周内边距
#define ZYPhotoEdgeInsets 10

// 图片保存成功提示文字
#define ZYPhotoBrowserSaveImageSuccessText @" 保存成功 ";

// 图片保存失败提示文字
#define ZYPhotoBrowserSaveImageFailText @" 保存失败 ";

//下图模式下 背景颜色
#define ZYSmallPhotoBackgrounColor [UIColor whiteColor]

// 照片浏览器的背景颜色
#define ZYPhotoBrowserBackgrounColor [UIColor blackColor]

// 照片浏览器中 图片之间的margin
#define ZYPhotoBrowserImageViewMargin 10

// 照片浏览器中 屏幕旋转时 使用这个时间 来做动画修改图片的展示
#define ZYAnimationDuration 0.35f

// 照片浏览器中 显示图片动画时长
#define ZYPhotoBrowserShowImageAnimationDuration 0.35f

// 照片浏览器中 隐藏图片动画时长
#define ZYPhotoBrowserHideImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（ZYWaitingViewModeLoopDiagram 圆形空心，ZYWaitingViewModePieDiagram 圆形实心）
#define ZYWaitingViewProgressMode ZYWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define ZYWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define ZYWaitingViewItemMargin 10

