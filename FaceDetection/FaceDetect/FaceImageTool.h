//
//  FaceImageTool.h
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface FaceImageTool : NSObject

+(instancetype)defaultFaceImageTool;

-(UIImage*)detectFaceImageFrom:(CMSampleBufferRef) sampleBuffer;
+(BOOL)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+(UIImage*)getImageFormSandBoxWithName:(NSString *)imageName;
+(NSString*)getFullPathWithName:(NSString*)name;
@end
