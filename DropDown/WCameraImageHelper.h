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

@interface WCameraImageHelper : NSObject 


- (id)initPreView:(UIView*)preview;

- (void)captureImage;
- (void)toggleMovieRecording;
- (void)stopMoiveRecord;



@end
