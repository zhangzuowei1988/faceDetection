//
//  FaceDetectView.h
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DetectorFaceBlock)(UIImage *face);

@interface FaceDetectView : UIView

@property(nonatomic,copy)DetectorFaceBlock detectorFaceBlock;
-(void)startDetecting;
-(void)stopDetecting;
@end
