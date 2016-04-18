//
//  ZYPhotoBrowserView.h
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPhotoBrowserView : UIView
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);
@property (nonatomic,strong) void (^longTabBlock)(UILongPressGestureRecognizer *recognizer);
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
