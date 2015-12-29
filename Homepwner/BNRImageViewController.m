//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by 倪之欣 on 15/12/18.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation BNRImageViewController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)loadView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.imageView setCenter:CGPointMake(600/2, 600/2)];
    
    scrollView.contentSize = self.imageView.frame.size;
    scrollView.scrollEnabled = NO;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    
    [scrollView addSubview:self.imageView];
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIImageView *imageView = (UIImageView *)self.view;
//    imageView.image = self.image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
