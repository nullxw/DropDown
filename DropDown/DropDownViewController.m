//
//  DropDownViewController.m
//  DropDown
//
//  Created by Lsgo on 14/11/4.
//  Copyright (c) 2014年 Lsgo. All rights reserved.
//

#import "DropDownViewController.h"
#import "DropDownView.h"

@interface DropDownViewController ()

@end

@implementation DropDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self tapGestureForFriendInfoView:_cameraPreview];
    [self addDropView];
    [self addCameraPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addDropView{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"DropDownView" owner:self options:nil];
    dropDownView = [array objectAtIndex:0];
    dropDownView.frame=CGRectMake(0, 0.0f - 100, dropDownView.frame.size.width, 100);
    [dropDownView addEyeLayer];
    dropDownView.strokeColor = [UIColor whiteColor];
    [self.dropDownTableView addSubview:dropDownView];

}

-(void)addCameraPreview{
    wcameraHelper = [[WCameraImageHelper alloc]initPreView:_cameraPreview];
}
-(IBAction)cancelBtnTapp:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        _dropDownTableView.frame = CGRectMake(0, 64, _dropDownTableView.frame.size.width, _dropDownTableView.frame.size.height);
    } completion:^(BOOL finished) {
        _cancelButton.hidden=YES;
        _cameraPreview.hidden=YES;
        _operationView.hidden=YES;
    }];
}
#pragma mark
#pragma mark GestureRecognizer
-(void)tapGestureForFriendInfoView:(UIView*)touchView{
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlesSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [touchView setUserInteractionEnabled:YES];
    [touchView addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longTap =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleLongTouch:)];
    longTap.minimumPressDuration = 0.6;
    [touchView setUserInteractionEnabled:YES];
    [touchView addGestureRecognizer:longTap];
    [singleTap requireGestureRecognizerToFail:longTap];
}
#pragma mark GestureRecognizer Action
-(void)handlesSingleTap:(UIGestureRecognizer*)sender{
    [wcameraHelper captureImage];
}
-(void)handleLongTouch:(UILongPressGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        AudioServicesPlaySystemSound (1113); // SMSReceived (see SystemSoundID below)
        [wcameraHelper toggleMovieRecording];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        AudioServicesPlaySystemSound (1114); // SMSReceived (see SystemSoundID below)
        [wcameraHelper stopMoiveRecord];
    }
}
#pragma mark uitableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure a cell to show the corresponding string from the array.
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = @"测试AABBCCC";
    return cell;
}

#pragma mark uiscrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"yOffset===%f",yOffset);
    NSLog(@"%f",-(yOffset/110));

    if (yOffset <= -160) {
        [UIView animateWithDuration:1.0 animations:^{
            _dropDownTableView.frame = CGRectMake(_dropDownTableView.frame.origin.x, 568, _dropDownTableView.frame.size.width, _dropDownTableView.frame.size.height);
        } completion:^(BOOL finished) {
            _cancelButton.hidden=NO;
            _cameraPreview.hidden=NO;
            _operationView.hidden=NO;
        }];
    }else{
        [self setLayerOpaticy: -(yOffset/110)];
        [self setLayerStroke:-(yOffset/110)];
    }
}

-(void)setLayerOpaticy:(CGFloat)opacity{
    [dropDownView animateLayerAtoAlpha:opacity];
    [dropDownView animateLayerBtoAlpha:opacity];
    [dropDownView animateToAlphaEnd:opacity];
    
    [dropDownView animateLeftTopToOpcity:opacity];
    [dropDownView animateRightTopToOpcity:opacity];
    [dropDownView animateLeftBottomToOpcity:opacity];
    [dropDownView animateRightBottomToOpcity:opacity];
}

-(void)setLayerStroke:(CGFloat)stoked{
    
    [dropDownView animateLeftTopToStrokeEnd:stoked];
    [dropDownView animateRightTopToStrokeEnd:stoked];
    [dropDownView animateLeftBottomToStrokeEnd:stoked];
    [dropDownView animateRightBottomToStrokeEnd:stoked];
}
#pragma mark uibuttion action
-(IBAction)takePhoto:(id)sender{
    [wcameraHelper captureImage];
}

-(IBAction)startMoiveRecoding:(id)sender{
    [wcameraHelper toggleMovieRecording];
}

-(IBAction)endMoiveRecord:(id)sender{
    [wcameraHelper stopMoiveRecord];
}
@end
