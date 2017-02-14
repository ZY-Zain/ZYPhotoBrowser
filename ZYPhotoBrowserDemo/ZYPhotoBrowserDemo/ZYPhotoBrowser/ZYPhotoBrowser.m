//
//  HZPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "ZYPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "ZYPhotoBrowserView.h"
#import "ZYPhotoCollectionView.h"
//第三方
#import "Masonry.h"
#import "MBProgressHUD.h"
//统一配置文件
#import "ZYPhotoBrowserConfig.h"

@implementation ZYPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    UIView *_contentView;
    UIPageControl *_pageControl;
    UIAlertView *_savePhotoAlertView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZYPhotoBrowserBackgrounColor;
    }
    return self;
}

- (void)didMoveToSuperview
{
    
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupToolbars
{
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(ZYAPPWidth * 0.5, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }
    
    UIPageControl *page = [[UIPageControl alloc] init];
    page.pageIndicatorTintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    page.numberOfPages = self.imageCount;
    [self addSubview:page];
    _pageControl = page;
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5);
        make.top.mas_equalTo(self.bounds.size.height - 30 - 37);
    }];
    
    if (self.imageCount == 1) {
        _pageControl.hidden = YES;
    }
    BOOL showNumPage = ZYPageType == ZYNumPageType ? YES : NO;
    if (showNumPage) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    } else {
        [_indexLabel removeFromSuperview];
        _indexLabel = nil;
    }
}

#pragma mark 保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    ZYPhotoBrowserView *currentView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    NSString *success = ZYPhotoBrowserSaveImageSuccessText;
    NSString *fail = ZYPhotoBrowserSaveImageFailText;
    NSString *successImage = @"success.png";
    NSString *errorImage = @"error.png";
    if (error) {
        UIView *view = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = fail;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", errorImage]]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    } else {
        UIView *view = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = success;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", successImage]]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        ZYPhotoBrowserView *view = [[ZYPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoClick:recognizer];
        };
        view.longTabBlock = ^(UILongPressGestureRecognizer *recognizer) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoLongClick:recognizer];
        };

        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    ZYPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += ZYPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - ZYPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;

    [_scrollView.subviews enumerateObjectsUsingBlock:^(ZYPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = ZYPhotoBrowserImageViewMargin + idx * (ZYPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 55, 30);

    
    if (_pageControl) {
        [_pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5);
            make.top.mas_equalTo(self.bounds.size.height - 30 - 37);
        }];
    }
}

- (void)show
{
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = ZYPhotoBrowserBackgrounColor;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    self.center = CGPointMake(_contentView.bounds.size.width * 0.5, _contentView.bounds.size.height * 0.5);
    self.bounds = CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height);
    
    [_contentView addSubview:self];
    
    window.windowLevel = UIWindowLevelStatusBar+10.0f;
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:ZYPhotoBrowserShowImageAnimationDuration + 0.2];
    
    [window addSubview:_contentView];
}
- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange
{
    if (!ZYISShouldLandscape) {
        return;
    }
    ZYPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;

    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:ZYAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }else if (orientation==UIDeviceOrientationPortrait){
        [UIView animateWithDuration:ZYAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.bounds = screenBounds;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }
}

#pragma mark - 开始大图模式
- (void)showFirstImage
{
    ZYPhotoCollectionView * collectionView = (ZYPhotoCollectionView *)self.sourceImagesContainerView;
    UICollectionViewCell * cell;
    if (collectionView.photoModelArray.count == 4 && self.currentImageIndex > 1) {
        cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex + 1 inSection:0]];
    } else {
        cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:cell.frame toView:self];

    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.frame = rect;
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self addSubview:tempView];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat placeImageSizeW = tempView.image.size.width;
    CGFloat placeImageSizeH = tempView.image.size.height;
    CGRect targetTemp;

    CGFloat placeHolderH = (placeImageSizeH * ZYAPPWidth)/placeImageSizeW;
    if (placeHolderH <= ZYAppHeight) {
        targetTemp = CGRectMake(0, (ZYAppHeight - placeHolderH) * 0.5 , ZYAPPWidth, placeHolderH);
    } else {
        targetTemp = CGRectMake(0, 0, ZYAPPWidth, placeHolderH);
    }

    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _pageControl.hidden = YES;

    [UIView animateWithDuration:ZYPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
        _saveButton.hidden = NO;
        _pageControl.hidden = NO;
    }];
}

#pragma mark - 代理方法
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    
    _pageControl.currentPage = index;

    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    self.currentImageIndex = autualIndex;
    for (ZYPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - tap
#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    ZYPhotoBrowserView *view = (ZYPhotoBrowserView *)recognizer.view;
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
    
    CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;
    CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;
    [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES];
    }
    
}

#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    ZYPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _pageControl.hidden = YES;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIDeviceOrientationPortrait];
            self.transform = CGAffineTransformIdentity;
            self.bounds = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self hidePhotoBrowser:recognizer];
        }];
    } else {
        [self hidePhotoBrowser:recognizer];
    }
}

#pragma mark - 长按
-(void)photoLongClick:(UILongPressGestureRecognizer *)recognizer {
        if (_savePhotoAlertView != nil) {
            return;
        }
        _savePhotoAlertView = [[UIAlertView alloc] initWithTitle:@"保存图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [_savePhotoAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else if (buttonIndex == 1){
        [self saveImage];
    }
    _savePhotoAlertView = nil;
}


#pragma mark - 退出大图模式
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    ZYPhotoBrowserView *view = (ZYPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    ZYPhotoCollectionView * collectionView = (ZYPhotoCollectionView *)self.sourceImagesContainerView;
    UICollectionViewCell * cell;
    if (collectionView.photoModelArray.count == 4 && self.currentImageIndex > 1) {
        cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex + 1 inSection:0]];
    } else {
        cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
    }

    CGRect targetTemp = [self.sourceImagesContainerView convertRect:cell.frame toView:self];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    CGFloat tempImageViewH = (tempImageSizeH * ZYAPPWidth)/tempImageSizeW;
    
    if (tempImageViewH < ZYAppHeight) {
        tempImageView.frame = CGRectMake(0, (ZYAppHeight - tempImageViewH)*0.5, ZYAPPWidth, tempImageViewH);
    } else {
        tempImageView.frame = CGRectMake(0, 0, ZYAPPWidth, tempImageViewH);
    }
    [self addSubview:tempImageView];
    
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    _scrollView.hidden = YES;
    _pageControl.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;
    [UIView animateWithDuration:ZYPhotoBrowserHideImageAnimationDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
}

@end
