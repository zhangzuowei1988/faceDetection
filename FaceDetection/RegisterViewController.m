//
//  RegisterViewController.m
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import "RegisterViewController.h"
#import "FaceDetectView.h"
#import "FaceImageTool.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, self.view.frame.size.height- 200, 200, 200)];
    FaceDetectView *faceDetectView = [[FaceDetectView alloc]initWithFrame:self.view.bounds];
    __weak FaceDetectView *weakFaceDetectView =faceDetectView;
    faceDetectView.detectorFaceBlock = ^(UIImage *face) {
        if (face) {
           imageView.image = face;
            [weakFaceDetectView stopDetecting];
            //检测到完整人脸；
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [FaceImageTool saveImage:face withName:@"faceImage"];
            });
            [self performSelector:@selector(registerComplete) withObject:nil afterDelay:2];
        }
    };
    [self.view addSubview:faceDetectView];
    [self.view addSubview:imageView];
}
-(void)registerComplete
{
    [self.navigationController popViewControllerAnimated:YES];
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
