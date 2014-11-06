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

@implementation WCameraImageHelper
@synthesize sessionQueue;

static WCameraImageHelper *sharedInstance = nil;

-(void)dealloc{
    NSLog(@"WCameraImageHelper dealloc!!!!!!!!!!!!!!!!!");
    [self.session stopRunning];
}

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
    //  设置采集大小
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    dispatch_async(sessionQueue, ^{
        NSError *error = nil;
        
        AVCaptureDevice *device = [self frontCamera];
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!captureInput){
            NSLog(@"Error: %@", error);
            return;
        }
        [self.session addInput:captureInput];
        
        
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


-(void)captureimage{
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


@end
