//
//  LoginViewController.m
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import "LoginViewController.h"
#import "FaceDetectView.h"
#import "CalculateImageSimilarity.h"
#import "FaceImageTool.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- 100, 100, 100)];
    userImageView.image =[FaceImageTool getImageFormSandBoxWithName:@"faceImage"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height- 100, 100, 100)];
    FaceDetectView *faceDetectView = [[FaceDetectView alloc]initWithFrame:self.view.bounds];
    faceDetectView.detectorFaceBlock = ^(UIImage *face) {
        if (face) {
            imageView.image = face;
            UIImage *userImage = [FaceImageTool getImageFormSandBoxWithName:@"faceImage"];
            
            //计算两种图片的相似度还有问题
            NSInteger count = [CalculateImageSimilarity getSimilarityValueWithImgA:face ImgB:userImage];
            NSLog(@"相似度---%ld",(long)count);
        }
    };
    [self.view addSubview:faceDetectView];
    [self.view addSubview:imageView];
    [self.view addSubview:userImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
