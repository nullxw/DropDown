//
//  WCameraImageHelper.m
//  Po
//
//  Created by Lsgo on 14-10-29.
//  Copyright (c) 2014年 Allan.Chan. All rights reserved.
//

#import "WCameraImageHelper.h"

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WCameraImageHelper()<AVCaptureFileOutputRecordingDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) UIImageOrientation imageOrientation;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@end

@implementation WCameraImageHelper
@synthesize sessionQueue;

static WCameraImageHelper *sharedInstance = nil;

-(void)dealloc{
    NSLog(@"WCameraImageHelper dealloc!!!!!!!!!!!!!!!!!");
    [self.session stopRunning];
}

#pragma mark init
-(id)init{
    if (self = [super init]){
    }
    return self;
}
- (id)initPreView:(UIView*)preview
{
    if (self = [super init]){
        NSString *mediaType = AVMediaTypeVideo;
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted)
            {
                //Granted access to mediaType
                [self setDeviceAuthorized:YES];
                [self initializeWithView:preview];
            }
            else
            {
                //Not granted access to mediaType
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"提示!"
                                                message:@"请在设置里面允许程序访问相机"
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                    [self setDeviceAuthorized:NO];
                });
            }
        }];
    }
    return self;
}

- (void) initializeWithView:(UIView*)aview
{
    dispatch_queue_t sessionQueueA = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueueA];
    
    self.session = [[AVCaptureSession alloc] init];
    //  设置采集大小,在视频模式下，此行代码会造成崩溃
//    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    dispatch_async(sessionQueue, ^{
        NSError *error = nil;
        
        
        //set  input
        AVCaptureDevice *device = [self backCamera];
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!captureInput){
            NSLog(@"Error: %@", error);
            return;
        }
        [self.session addInput:captureInput];
        //set audioInput
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (error)
        {
            NSLog(@"%@", error);
        }
        if ([self.session canAddInput:audioDeviceInput])
        {
            [self.session addInput:audioDeviceInput];
        }
        //set moiveOutput
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([self.session canAddOutput:movieFileOutput])
        {
            [self.session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported])
                [connection setEnablesVideoStabilizationWhenAvailable:YES];
            [self setMovieFileOutput:movieFileOutput];
        }
        //set imageOutput
        self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        if ([self.session canAddOutput:self.captureOutput])
        {
            NSLog(@"添加输出设备");
            self.captureOutput.outputSettings = outputSettings;
            [self.session addOutput:self.captureOutput];
        }
        [self.session startRunning];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self embedPreviewInViewWithView:aview];
        });
    });
}


- (void)embedPreviewInViewWithView: (UIView *) aView {
        if (!self.session){
            return;
        }
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
        self.preview.frame = CGRectMake(0, 0, 320, 300);
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [aView.layer addSublayer: self.preview];
}

#pragma mark Actions

-(void)captureImage{
    if (_deviceAuthorized==NO) {
        return;
    }
    dispatch_async(sessionQueue, ^{
        // 5.获取连接
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in self.captureOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) {
                break;
            }
        }
        
        // 6.获取图片
        [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, nil);
            if (exifAttachments) {
                // Do something with the attachments.
            }
            // 获取图片数据
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *t_image = [[UIImage alloc] initWithData:imageData];
            self.image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.5 orientation:UIImageOrientationRight];
            
            [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[t_image CGImage] orientation:(ALAssetOrientation)[t_image imageOrientation] completionBlock:nil];
            
        }];
    });
}

- (void)toggleMovieRecording{
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording])
        {
            
            if ([[UIDevice currentDevice] isMultitaskingSupported])
            {
            }
            
            // Start recording to a temporary file.
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
            }
            
            [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
        else
        {
            [[self movieFileOutput] stopRecording];
        }
    });
}
-(void)stopMoiveRecord{
    dispatch_async([self sessionQueue], ^{
        if (![[self movieFileOutput] isRecording])
        {
        }
        else
        {
            [[self movieFileOutput] stopRecording];
        }
    });
}
#pragma mark get device
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"didFinishRecordingToOutputFileAtURL");
    if (error)
        NSLog(@"%@", error);
    
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
            NSLog(@"%@", error);
        
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
    
    }];
}

@end
