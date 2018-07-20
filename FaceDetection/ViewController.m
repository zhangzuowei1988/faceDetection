//
//  ViewController.m
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)registerButtonClicked:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    LoginViewController *LoginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
