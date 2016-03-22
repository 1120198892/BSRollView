//
//  BSRollView.m
//  BSRollView
//
//  Created by erice on 16/3/22.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "BSRollView.h"
#import "UIImageView+WebCache.h"

#define pageSize 16
#define ScrollWidth self.frame.size.width
#define ScrollHeight self.frame.size.height



@interface BSRollView ()<UIScrollViewDelegate>

{
    BOOL _isNet;
}
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, copy)   BSRollClickedAction actionBlock;
@end



@implementation BSRollView

{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    NSInteger _currentIndex;
    NSInteger _MaxImageCount;

}


- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSArray *)imageArray clickedAtIndex:(BSRollClickedAction)rollBlock;
{
    if (imageArray.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        _isNet = [[imageArray lastObject] containsString:@"http"] == YES?YES:NO;
        if (rollBlock) {
          self.actionBlock =rollBlock;
        }
        [self createScrollView];
        [self initImageArray:imageArray];
        [self initMaxImageCount:_imageArray.count];
    }
    
    return self;
}

#pragma mark - init

- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    _rollDelay = 0;
    _currentIndex = 0;
    _scrollView = scrollView;
}


-(void)initImageArray:(NSArray *)imageArray
{
    if (_isNet)
    {
        _imageArray = [imageArray copy];
        
    }else {
      
        NSMutableArray *localimageArray = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (NSString *imageName in imageArray) {
            [localimageArray addObject:[UIImage imageNamed:imageName]];
        }
        _imageArray = [localimageArray copy];
    }
}

-(void)initMaxImageCount:(NSInteger)MaxImageCount
{
    _MaxImageCount = MaxImageCount;
    [self initImageView];
    [self createPageControl];
    [self setUpTimer];
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
}

- (void)initImageView {
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth, 0,ScrollWidth, ScrollHeight)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth * 2, 0,ScrollWidth, ScrollHeight)];
    
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}



-(void)createPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,ScrollHeight - pageSize,ScrollWidth, 8)];
    
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.numberOfPages = _MaxImageCount;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    _PageControl = pageControl;
}



#pragma mark - 定时器

- (void)setUpTimer
{
    if (_rollDelay < 0.5) return;
    
    _timer = [NSTimer timerWithTimeInterval:_rollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeImageWithOffset:scrollView.contentOffset.x];
}


#pragma mark - Api

- (void)imageViewDidTap
{
    if (self.actionBlock) {
        self.actionBlock(_currentIndex);
    }
}



- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= ScrollWidth * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
    }
}

#pragma mark - 复用

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNet)
    {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
        
    }else
    {
        _leftImageView.image = _imageArray[LeftIndex];
        _centerImageView.image = _imageArray[centerIndex];
        _rightImageView.image = _imageArray[rightIndex];
    }
    
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

-(void)dealloc
{
    [self removeTimer];
}
#pragma mark - set

- (void)setRollDelay:(NSTimeInterval)rollDelay
{
    _rollDelay = rollDelay;
    [self removeTimer];
    [self setUpTimer];
}



@end
