//
//  DropDownView.h
//  DropDown
//
//  Created by Lsgo on 14/11/4.
//  Copyright (c) 2014年 Lsgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView

@property(nonatomic) UIColor *strokeColor;

-(void)addEyeLayer;

- (void)animateLayerAtoAlpha:(CGFloat)alphaEnd;
- (void)animateLayerBtoAlpha:(CGFloat)alphaEnd;
- (void)animateToAlphaEnd:(CGFloat)alphaEnd;

-(void)animateLeftTopToOpcity:(CGFloat)alphaEnd;
-(void)animateRightTopToOpcity:(CGFloat)alphaEnd;
-(void)animateLeftBottomToOpcity:(CGFloat)alphaEnd;
-(void)animateRightBottomToOpcity:(CGFloat)alphaEnd;

-(void)animateLeftTopToStrokeEnd:(CGFloat)strokeEnd;
-(void)animateRightTopToStrokeEnd:(CGFloat)strokeEnd;
-(void)animateLeftBottomToStrokeEnd:(CGFloat)strokeEnd;
-(void)animateRightBottomToStrokeEnd:(CGFloat)strokeEnd;

@end
