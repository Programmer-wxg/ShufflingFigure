//
//  ViewController.m
//  轮播图
//
//  Created by xhkj on 2018/7/31.
//  Copyright © 2018年 WXG. All rights reserved.
//

#import "ViewController.h"
#import "PageLeaderView.h"

#define VIEW_W [UIScreen mainScreen].bounds.size.width

#define LeaderView_Height VIEW_W*1200/1920

@interface ViewController ()
@property (nonatomic,strong) PageLeaderView *leaderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leaderView = [[PageLeaderView alloc] initWithFrame:CGRectMake(0, 100, VIEW_W, LeaderView_Height)];
    [self.leaderView CreatePageLeaderView:nil Target:self Action:@selector(SingleTap:)];
    [self.view addSubview:self.leaderView];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    
    NSLog(@"图片点击tap == %ld",recognizer.view.tag);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
