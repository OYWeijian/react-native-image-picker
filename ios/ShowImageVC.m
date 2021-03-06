//
//  ShowImageVC.m
//  imageCropPicker
//
//  Created by 欧阳伟坚 on 2018/4/3.
//  Copyright © 2018年 Ivan Pusic. All rights reserved.
//

#import "ShowImageVC.h"

#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ShowImageVC ()

@end

@implementation ShowImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏电源状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    [self prefersStatusBarHidden];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *newImage = [self imageAddText:self.dataImage text:self.location];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:newImage];
    
//    imageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    imageView.frame = CGRectMake(0, KScreenHeight * 0.05, KScreenWidth, KScreenHeight * 0.85);
    [self.view addSubview:imageView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"重拍" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton sizeToFit];
    leftButton.center = CGPointMake(30, KScreenHeight-30);
    [leftButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn sizeToFit];
    rightBtn.center = CGPointMake(KScreenWidth - 50, KScreenHeight-30);
    [rightBtn addTarget:self action:@selector(makeSureImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    self.dataImage = newImage;
}

//隐藏单个页面电池条的方法
- (BOOL)prefersStatusBarHidden{
    return YES;  //隐藏
}

-(void) popView {
    self.dataImage = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) makeSureImage {
    
    NSNotification *notification = [NSNotification notificationWithName:@"image" object:self.dataImage];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

// 给图片添加文字水印：
- (UIImage *)imageAddText:(UIImage *)img text:(NSString *)logoText{
    
    NSString* mark = logoText;
    
    int w = img.size.width;
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor whiteColor]  };

    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    

    //位置显示
    if (mark && mark.length <= 20) {
        
        [currentTimeString drawInRect:CGRectMake(10, h - 45, w*0.8, h*0.3) withAttributes:attr];
        [mark drawInRect:CGRectMake(10, h - 25, w*0.8, h*0.5) withAttributes:attr];
    }
    else if (mark && mark.length > 20 ) {
        
        [currentTimeString drawInRect:CGRectMake(10, h - 60, w*0.8, h*0.3) withAttributes:attr];
        [mark drawInRect:CGRectMake(10, h - 40, w*0.8, h*0.5) withAttributes:attr];
    }
    else{
        
        [currentTimeString drawInRect:CGRectMake(10, h - 25, w*0.8, h*0.3) withAttributes:attr];
    }
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}



@end
