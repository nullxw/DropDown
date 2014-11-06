//
//  WCameraImageHelper.h
//  Po
//
//  Created by Lsgo on 14-10-29.
//  Copyright (c) 2014年 Allan.Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface WCameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) UIImageOrientation imageOrientation;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.

- (id)initPreView:(UIView*)preview;
- (void)captureimage;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;

@end
