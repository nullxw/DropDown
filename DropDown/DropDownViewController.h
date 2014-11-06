//
//  DropDownViewController.h
//  DropDown
//
//  Created by Lsgo on 14/11/4.
//  Copyright (c) 2014年 Lsgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "WCameraImageHelper.h"

@interface DropDownViewController : UIViewController<UIScrollViewDelegate>{
    DropDownView *dropDownView;
    WCameraImageHelper *wcameraHelper;
}
@property(nonatomic,weak)IBOutlet UITableView *dropDownTableView;
@property(nonatomic,weak)IBOutlet UIButton *cancelButton;
@property(nonatomic,weak)IBOutlet UIView *cameraPreview;
@property(nonatomic,weak)IBOutlet UIView *operationView;

@end
