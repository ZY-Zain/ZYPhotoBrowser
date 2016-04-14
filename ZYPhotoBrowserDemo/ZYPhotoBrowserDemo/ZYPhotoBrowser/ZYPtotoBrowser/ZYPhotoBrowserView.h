//
//  HZPhotoBrowserView.h
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15/5/7.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPhotoBrowserView : UIView
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL beginLoadingImage;
//@property (nonatomic, assign) BOOL beginLoadingImage;
//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);
//长按回调
@property (nonatomic,strong) void (^longTabBlock)(UILongPressGestureRecognizer *recognizer);
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
