//
//  PageLeaderView.m
//  kuaye-ios
//
//  Created by JPY on 17/6/21.
//  Copyright © 2017年 WXG. All rights reserved.
//

#import "PageLeaderView.h"
#import "ColorHexString.h"

#define PAGE_W_H 30
#define PAGE_Y 85
#define SCROLLER_H 120

#define VIEW_W [UIScreen mainScreen].bounds.size.width
#define VIEW_H [UIScreen mainScreen].bounds.size.height

#define LeaderView_Height VIEW_W*1200/1920

#define UIColorFromHex_Gray @"#999999"
#define UIColorFromHex_White @"#ffffff"

@interface PageLeaderView ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
}

@property (nonatomic,strong) UIScrollView *scV;
@property (nonatomic,strong) UIPageControl *pageC;
@property (nonatomic,strong) UIView *BgView;
@property (nonatomic,strong) NSMutableArray *photoArray;
@end

@implementation PageLeaderView

#pragma mark - 创建广告栏
- (void)CreatePageLeaderView:(NSArray *)array Target:(id)target Action:(SEL)action
{
    [self RepeatDataArray:array];
    
    [self setQiDongScrollView:target Action:action];
    
    [self setMyPageControlView];
    
    [self addNSTimer];
}

#pragma mark - 重组数组
- (void)RepeatDataArray:(NSArray *)array
{
    //保存数据
    //重新组装数组
    if (array.count == 0)
    {
        NSArray *photoArray = @[@"guanggao01.png",@"guanggao02.png",@"guanggao03.png",@"guanggao04.png",@"guanggao05.png",@"guanggao06.png",@"guanggao07.png",@"guanggao08.png"];
        self.photoArray = [[NSMutableArray alloc] initWithArray:photoArray];
        
        //把最后一张插入到第一个位置
        [self.photoArray insertObject:[photoArray lastObject] atIndex:0];
        //加入第一张图片作为最后一张图片
        [self.photoArray addObject:photoArray[0]];
    }
    else
    {
        self.photoArray = [[NSMutableArray alloc] initWithArray:array];
        
        //把最后一张插入到第一个位置
        [self.photoArray insertObject:[array lastObject] atIndex:0];
        //加入第一张图片作为最后一张图片
        [self.photoArray addObject:array[0]];
    }
    //NSArray *photoArray = @[@"guanggao1.jpg",@"guanggao2.jpg",@"guanggao3.jpg",@"guanggao4.jpg",@"guanggao5.jpg"];
}

#pragma mark - 制作scrollView
-(void)setQiDongScrollView:(id)target Action:(SEL)action{
    
    self.scV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W, LeaderView_Height)];
    
    //2.协议关联
    self.scV.delegate = self;
    
    self.scV.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scV];
    
    self.scV.bounces = NO;
    
    self.scV.showsHorizontalScrollIndicator = NO;
    
    //滚动视图的分页功能(默认为NO)
    self.scV.pagingEnabled = YES;
    
    //设置当前展示的位置(从代码上去改变scrollView的当前显示位置)
    [self.scV setContentOffset:CGPointMake(VIEW_W, 0)];
    
    self.scV.contentSize = CGSizeMake(self.scV.frame.size.width * (int)self.photoArray.count, 10);
    
    //添加三张图片到滚动视图中
    NSLog(@"self.photoArray.count == %ld",self.photoArray.count);
    for (int i = 0; i < self.photoArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.scV.frame.size.width, 0, self.scV.frame.size.width, self.scV.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        [self tapGestureRecognizer:imageView Target:target Action:action Tag:100+i];
        if ([[self.photoArray firstObject] isKindOfClass:[UIImage class]])
        {
            imageView.image = self.photoArray[i];
        }
        else
        {
            imageView.image = [UIImage imageNamed:self.photoArray[i]];
        }
        
        [self.scV addSubview:imageView];
    }
}

- (void)tap
{
    
}

#pragma 轻怕手势
-(void)tapGestureRecognizer:(UIImageView *)imageView Target:(id)target Action:(SEL)action Tag:(int)tag
{
    //创建手势对象
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:target  action:action];
    //配置属性
    //轻拍次数
    tap.numberOfTapsRequired =1;
    //轻拍手指个数
    tap.numberOfTouchesRequired =1;
    //讲手势添加到指定的视图上
    [imageView addGestureRecognizer:tap];
    
    UIView *tapView = [tap view];
    tapView.tag = tag;
}


#pragma mark -添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
}

#pragma mark -删除定时器
-(void)removeNSTimer
{
    [_timer invalidate];
    
    _timer = nil;
}

- (void)nextPage
{
    int num = (int)self.pageC.currentPage;
    //ZYLog(@"num == %d",num);
    CGRect frame = self.scV.frame;
    frame.origin.x = frame.size.width*(num+2);
    
    [self.scV scrollRectToVisible:frame animated:YES];
    if (num == self.photoArray.count - 3)
    {
        num = 0;
        self.pageC.currentPage = num;
        self.scV.contentOffset = CGPointMake(0,0);
    }
    else
    {
        self.pageC.currentPage = num+1;
    }
}

#pragma mark - 创建页码控制器
-(void)setMyPageControlView{
    //设置一个页面控制器
    self.pageC = [[UIPageControl alloc]init];
    NSLog(@"%lu",PAGE_W_H*(self.photoArray.count-2));
    //self.pageC.backgroundColor = [UIColor blueColor];
    self.pageC.frame = CGRectMake(100, CGRectGetHeight(self.scV.frame)-PAGE_W_H, PAGE_W_H, PAGE_W_H);
    CGPoint point = CGPointMake(VIEW_W/2, VIEW_H/2);
    self.pageC.center = point;
    self.pageC.frame = CGRectMake(CGRectGetMinX(self.pageC.frame), CGRectGetHeight(self.scV.frame)-PAGE_W_H, PAGE_W_H, PAGE_W_H);
    self.pageC.pageIndicatorTintColor = [ColorHexString colorWithHexString:UIColorFromHex_Gray];
    
    self.pageC.currentPageIndicatorTintColor = [ColorHexString colorWithHexString:UIColorFromHex_White];
    
    [self addSubview:self.pageC];
    
    //设置页码控制器的总页数
    self.pageC.numberOfPages = self.photoArray.count-2;
    
    self.pageC.currentPage = 0;
    
    //前提是用户交互,当前页码时改变所调用的方法
    [self.pageC addTarget:self action:@selector(pageNumberChange) forControlEvents:UIControlEventValueChanged];
}

#pragma mark 当前页码时改变所调用的方法
-(void)pageNumberChange
{
    //滚动到某个位置（使用动画）
    [self.scV scrollRectToVisible:CGRectMake((self.pageC.currentPage -1) * self.scV.frame.size.width, 0, self.scV.frame.size.width, self.scV.frame.size.height) animated:YES];
}

#pragma mark - scrollViewDelegate
//当scrollView滚动时回调的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动时，每隔一段时间（时间非常短），就会调用一下这个方法
    //    NSLog(@"滚动时回调的方法");
    //ZYLog(@"contentOffSet = %f",scrollView.contentOffset.x);
}

//将要拖拽scrollView时调用的方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"将要拖拽scrollView时调用的方法");
    [self removeNSTimer];
}

//scrollView结束自由滑动时调用的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollView结束自由滑动时调用的方法");
    [self addNSTimer];
    [self pageChange:self.scV];
}

#pragma mark - 写一个换页调用的方法
- (void)pageChange:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < self.scV.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.scV.frame.size.width *(self.photoArray.count -2),0);
    }else if (scrollView.contentOffset.x > self.scV.frame.size.width *(self.photoArray.count -2)){
        scrollView.contentOffset = CGPointMake(self.scV.frame.size.width,0);
    }
    
    //让pageC的页码跟随scrollView的滚动变化
    self.pageC.currentPage = scrollView.contentOffset.x/self.scV.frame.size.width - 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
