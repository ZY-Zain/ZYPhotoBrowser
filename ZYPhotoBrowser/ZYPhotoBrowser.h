//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HZButton, ZYPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(ZYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(ZYPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface ZYPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)show;

@end
