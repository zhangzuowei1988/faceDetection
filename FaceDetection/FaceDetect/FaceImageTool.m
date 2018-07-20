//
//  FaceImageTool.m
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import "FaceImageTool.h"

@implementation FaceImageTool
+(instancetype)defaultFaceImageTool
{
    return [[self alloc]init];
}

-(UIImage*)detectFaceImageFrom:(CMSampleBufferRef) sampleBuffer
{
    UIImage *originalImage = [self imageFromSampleBuffer:sampleBuffer];
    originalImage = [self fixOrientation:originalImage];
    UIImage *faceImage = [self detectFaceWithImage:originalImage];
    if (faceImage) {
        return faceImage;
    }
    return nil;
}
//识别脸部
-(UIImage*)detectFaceWithImage:(UIImage *)originImage
{
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *cIImg = [CIImage imageWithCGImage:originImage.CGImage];
    NSArray *features = [faceDetector featuresInImage:cIImg];

    for (CIFaceFeature *faceFeature in features) {
        //完成的脸部
  if(faceFeature.hasLeftEyePosition&&faceFeature.hasRightEyePosition&&faceFeature.hasMouthPosition) {
      CGRect faceBound = [self calculateFaceBoundsWith:[cIImg extent].size originSize:originImage.size faceBounds:faceFeature.bounds];
      //截取脸部
      CGImageRef faceImageRef = CGImageCreateWithImageInRect(originImage.CGImage, faceBound);
      UIImage *faceImage = [UIImage imageWithCGImage:faceImageRef];
      CGImageRelease(faceImageRef);
            return faceImage;
        }
    }
    return nil;
}
//计算脸部区域
- (CGRect)calculateFaceBoundsWith:(CGSize)inputImageSize originSize:(CGSize)viewSize faceBounds:(CGRect)faceBounds
{
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    CGRect faceViewBounds = CGRectApplyAffineTransform(faceBounds, transform);
    CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                        viewSize.height / inputImageSize.height);
    CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
    CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
    // 缩放
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    // 修正
    faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
    faceViewBounds.origin.x += offsetX;
    faceViewBounds.origin.y += offsetY;
    return faceViewBounds;
}
// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
    UIImage *result = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(videoImage);
    return result;
}


//用来处理图片翻转90度
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+(BOOL)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0);
   NSString *imagePath = [self getFullPathWithName:imageName];
  return [imageData writeToFile:imagePath atomically:NO];
}
+(UIImage*)getImageFormSandBoxWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageWithContentsOfFile:[self getFullPathWithName:imageName]];
    return image;
}
+(NSString*)getFullPathWithName:(NSString*)name
{
    NSString *imagePath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    imagePath = [imagePath stringByAppendingPathComponent:name];
    return imagePath;
}

@end
