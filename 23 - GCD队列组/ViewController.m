//
//  ViewController.m
//  23 - GCD队列组
//
//  Created by 肖晨 on 15/7/20.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    _imageView.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:_imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    __block UIImage *image1;
    dispatch_group_async(group, queue, ^{
        NSURL *url1 = [NSURL URLWithString:@"http://gb.cri.cn/mmsource/images/2015/06/20/a84e668eff1d40f590d53758f5cc332a.jpg"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        image1 = [UIImage imageWithData:data1];
        NSLog(@"----image1----%@",[NSThread currentThread]);
    });
    
    __block UIImage *image2;
    dispatch_group_async(group, queue, ^{
        
        NSURL *url2 = [NSURL URLWithString:@"http://cn.bing.com/s/a/hp_zh_cn.png"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        image2 = [UIImage imageWithData:data2];
        NSLog(@"----image2----%@",[NSThread currentThread]);
    });
    
    
    dispatch_group_notify(group, queue, ^{
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
        
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
            NSLog(@"----fullImage----%@",[NSThread currentThread]);
        });
    });
    
    
}

- (void)text1
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url1 = [NSURL URLWithString:@"http://gb.cri.cn/mmsource/images/2015/06/20/a84e668eff1d40f590d53758f5cc332a.jpg"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        UIImage *image1 = [UIImage imageWithData:data1];
        
        NSURL *url2 = [NSURL URLWithString:@"http://cn.bing.com/s/a/hp_zh_cn.png"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        UIImage *image2 = [UIImage imageWithData:data2];
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
        
        // 先得到合成的图片
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = fullImage;
        });
    });
}

@end
