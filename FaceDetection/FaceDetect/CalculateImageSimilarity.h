//
//  CalculateImageSimilarity.h
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CalculateImageSimilarity : NSObject

typedef double Similarity;
- (void)setImgWithImgA:(UIImage*)imgA ImgB:(UIImage*)imgB;//设置需要对比的图片
- (void)setImgAWidthImg:(UIImage*)img;
- (void)setImgBWidthImg:(UIImage*)img;
- (Similarity)getSimilarityValue; //获取相似度
+ (Similarity)getSimilarityValueWithImgA:(UIImage*)imga ImgB:(UIImage*)imgb;//类方法

@end
