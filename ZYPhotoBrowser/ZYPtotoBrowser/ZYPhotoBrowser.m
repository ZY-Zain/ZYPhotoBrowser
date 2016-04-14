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
    
    //保存图片弹窗选择器
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

//当视图移动完成后调用
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
    // 1. 序标
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
    //如果利用约束来控制横竖屏的切换，并不能直接取父控件来做参照物，只能根据bounds.size来计算 等同于不实用约束 直接计算frame，只不过结果用约束来固定。  并且在LayoutSubviews方法中 更新此约束值  因为当屏幕旋转后 系统会调用layoutSubviews的方法
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.mas_equalTo(0);
        //        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
        make.left.mas_equalTo(self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5);
        make.top.mas_equalTo(self.bounds.size.height - 30 - 37);
    }];
    
    if (self.imageCount == 1) {
        _pageControl.hidden = YES;
    }
    
    //本来这里可以直接根据宏定义来判断是否展示哪一个显示控件，但因为宏定义是预先指令 在编译前就已经知道结果 导致报警告分支中有代码永远不会被执行  所以只能采用一个变量来代替宏 做判断
    BOOL showNumPage = ZYPageType == ZYNumPageType ? YES : NO;
    if (showNumPage) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    } else {
        [_indexLabel removeFromSuperview];
        _indexLabel = nil;
    }
    
    
    // 2.保存按钮   这里我添加了一个长按弹框手势来进行保存图片  所以保存按钮就忽略了
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.layer.borderWidth = 0.1;
//    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
//    saveButton.layer.cornerRadius = 2;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [self addSubview:saveButton];
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
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 40);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = ZYPhotoBrowserSaveImageFailText;
    }   else {
        label.text = ZYPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
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
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoClick:recognizer];
        };
        
        //处理长按
        view.longTabBlock = ^(UILongPressGestureRecognizer *recognizer) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoLongClick:recognizer];
        };

        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
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
//    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += ZYPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
//    _scrollView.center = self.center;
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
            //        make.left.right.mas_equalTo(0);
            //        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
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
    
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    
    //就是一个单线程方法 延迟时间 调用方法 并且在方法中注册通知 通知是屏幕旋转时调用(无需打开手机的屏幕旋转)
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:ZYPhotoBrowserShowImageAnimationDuration + 0.2];
    
    [window addSubview:_contentView];
}
- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    //注册通知 当手机旋转时调用(即使手机屏幕旋转关闭都可以正常触发此通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/**
 *  手机屏幕发生旋转时 通知调用的方法
 */
-(void)onDeviceOrientationChange
{
    if (!ZYISShouldLandscape) {
        //不支持横屏 则直接return
        return;
    }
    //支持横屏
    ZYPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;

    if (UIDeviceOrientationIsLandscape(orientation)) {//屏幕左旋转 或者 右旋转  利用位移选项来同时选择两种状态
        [UIView animateWithDuration:ZYAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }else if (orientation==UIDeviceOrientationPortrait){//屏幕垂直，没有旋转
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
    //获取图片的父控件  然后根据点击cell的下标 取出对应的cell  再取出cell此时的frame 进行坐标系转换  然后通过转换后的坐标系进行一个将原照片(此时是小图)先放大至全屏 放大的同时开始加载大图
    ZYPhotoCollectionView * collectionView = (ZYPhotoCollectionView *)self.sourceImagesContainerView;
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
    
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
    } else {//图片高度>屏幕高度
        targetTemp = CGRectMake(0, 0, ZYAPPWidth, placeHolderH);
    }
    
    //先隐藏scrollview
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _pageControl.hidden = YES;

    [UIView animateWithDuration:ZYPhotoBrowserShowImageAnimationDuration animations:^{
        //将点击的临时imageview动画放大到和目标imageview一样大
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        //动画完成后，删除临时imageview，让目标imageview显示
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
//    int imageIndex = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.9) / _scrollView.bounds.size.width;
//    if (imageIndex >= self.imageCount - 1) {
//        imageIndex = (int)self.imageCount - 1;
//    }
//    if (imageIndex <= 0) {
//        imageIndex= 0;
//    }
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    
    _pageControl.currentPage = index;
    
//    NSLog(@"%i",imageIndex);
    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
    
//    [self setupImageOfImageViewForIndex:imageIndex];
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
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
    
    CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
    CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
    [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
    
}

#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    ZYPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
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
            //已经弹创了
            return;
        }
    
        NSLog(@"点击了长按");
        _savePhotoAlertView = [[UIAlertView alloc] initWithTitle:@"保存图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [_savePhotoAlertView show];
}

//点击确定按钮后的回调方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//        NSLog(@"取消");
    }else if (buttonIndex == 1){
//        NSLog(@"保存");
        [self saveImage];
    }
    //置空弹窗器
    _savePhotoAlertView = nil;
}


#pragma mark - 退出大图模式
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    ZYPhotoBrowserView *view = (ZYPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    
    //获取图片的父控件  然后根据点击cell的下标 取出对应的cell  再取出cell此时的frame 进行坐标系转换  然后通过转换后的坐标系进行一个将原照片(此时是小图)先放大至全屏 放大的同时开始加载大图
    ZYPhotoCollectionView * collectionView = (ZYPhotoCollectionView *)self.sourceImagesContainerView;
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];

    CGRect targetTemp = [self.sourceImagesContainerView convertRect:cell.frame toView:self];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    CGFloat tempImageViewH = (tempImageSizeH * ZYAPPWidth)/tempImageSizeW;
    
    if (tempImageViewH < ZYAppHeight) {//图片高度<屏幕高度
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
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [UIView animateWithDuration:ZYPhotoBrowserHideImageAnimationDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
}

@end
