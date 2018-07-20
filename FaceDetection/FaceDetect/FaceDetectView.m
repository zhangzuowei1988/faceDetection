//
//  FaceDetectView.m
//  FaceDetection
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zhangzuowei. All rights reserved.
//

#import "FaceDetectView.h"
#import <AVFoundation/AVFoundation.h>
#import "FaceImageTool.h"

@interface FaceDetectView ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong,nonatomic) AVCaptureVideoDataOutput   *captureVideoDataOutput;
@property (strong,nonatomic) AVCaptureSession           *captureSession;
@property (strong,nonatomic) AVCaptureDeviceInput       *captureDeviceInput;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation FaceDetectView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCameraSession];
    }
    return self;
}
#pragma mark - 初始化相机
- (void)initCameraSession
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得前置摄像头
    if (!captureDevice) {
        NSLog(@"取得前置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    [_captureSession addInput:_captureDeviceInput];
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    _captureVideoPreviewLayer.frame=self.frame;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [(AVCaptureVideoPreviewLayer*)self.layer addSublayer:_captureVideoPreviewLayer];
    // 初始化数据流
    [self addVidelDataOutput];
}

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}
/**
 *  AVCaptureVideoDataOutput 获取数据流
 */
- (void)addVidelDataOutput
{
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *settings = @{key:value};
    [captureOutput setVideoSettings:settings];
    [self.captureSession addOutput:captureOutput];
    [self.captureSession startRunning];
}
#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        NSArray *devices  = deviceSession.devices;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
#pragma mark - Samle Buffer Delegate
// 抽样缓存写入时所调用的委托程序
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {

   UIImage *faceImage = [[FaceImageTool defaultFaceImageTool] detectFaceImageFrom:sampleBuffer];
    if (faceImage) {
        [self.captureSession stopRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detectorFaceBlock(faceImage);
        });
    }
    }
}

-(void)startDetecting
{
    [self.captureSession startRunning];
}
-(void)stopDetecting
{
    [self.captureSession stopRunning];
}
-(void)dealloc
{
    [self.captureSession stopRunning];
    
}
@end
