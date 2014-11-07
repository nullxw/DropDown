//
//  DropDownView.m
//  DropDown
//
//  Created by Lsgo on 14/11/4.
//  Copyright (c) 2014年 Lsgo. All rights reserved.
//

#import "DropDownView.h"
#import <POP/POP.h>


@interface DropDownView()
@property(nonatomic) CAShapeLayer *circleLayer;
@property(nonatomic) CAShapeLayer *squareLayerA;
@property(nonatomic) CAShapeLayer *squarelayerB;
@property(nonatomic) CAShapeLayer *bowLayer;
@property(nonatomic) CAShapeLayer *leftTopLayer;
@property(nonatomic) CAShapeLayer *rightTopLayer;
@property(nonatomic) CAShapeLayer *leftBottomLayer;
@property(nonatomic) CAShapeLayer *rightBottomLayer;
- (void)animateToStrokeEnd:(CGFloat)strokeEnd;
@end

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(frame.size.width == frame.size.height, @"A circle must have the same height and width.");
    }
    return self;
}


#pragma mark - Property Setters

- (void)setStrokeColor:(UIColor *)strokeColor
{
    self.circleLayer.strokeColor = strokeColor.CGColor;
    _strokeColor = strokeColor;
}

#pragma mark - Add layer methods

-(void)addEyeLayer{
    [self addSquareLayerA];
    [self addSquarelayerB];
    [self addCircleLayer];
    [self addLeftTopLayer];
    [self addRightTopLayer];
    [self addLeftBottomLayer];
    [self addRightBottomLayer];
}

- (void)addCircleLayer
{
    CGFloat lineWidth = 2.0;
    CGFloat radius = 20;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(140, 15, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       cornerRadius:radius].CGPath;
    
    self.circleLayer.strokeColor = self.tintColor.CGColor;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;//线条拐角
    self.circleLayer.lineJoin = kCALineJoinRound; //终点处理
    self.circleLayer.opacity = 0;
    
    [self.layer addSublayer:self.circleLayer];
}

-(void)addSquareLayerA{
    self.squareLayerA = [CAShapeLayer layer];
    self.squareLayerA.strokeColor = [UIColor whiteColor].CGColor;
    self.squareLayerA.fillColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(145, 36)];
    // Draw the lines
    [aPath addLineToPoint:CGPointMake(154, 41)];
    [aPath addLineToPoint:CGPointMake(155, 39)];
    [aPath addLineToPoint:CGPointMake(147, 33)];
    [aPath closePath];//第四条线通过调用closePath方法得到的
    
    self.squareLayerA.path =aPath.CGPath;
    self.squareLayerA.opacity = 0;
    [self.layer addSublayer:self.squareLayerA];
    
}

-(void)addSquarelayerB{
    self.squarelayerB = [CAShapeLayer layer];
    self.squarelayerB.strokeColor = [UIColor whiteColor].CGColor;
    self.squarelayerB.fillColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(150, 27)];
    // Draw the lines
    [aPath addLineToPoint:CGPointMake(158, 34)];
    [aPath addLineToPoint:CGPointMake(158, 30)];
    [aPath addLineToPoint:CGPointMake(154, 23)];
    [aPath closePath];//第四条线通过调用closePath方法得到的
    
    self.squarelayerB.path =aPath.CGPath;
    self.squarelayerB.opacity = 0;
    [self.layer addSublayer:self.squarelayerB];
}

- (void)addLeftTopLayer
{
    self.leftTopLayer = [CAShapeLayer layer];
    self.leftTopLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.leftTopLayer.fillColor = nil;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(161, 5)];
    [aPath addQuadCurveToPoint:CGPointMake(125, 41) controlPoint:CGPointMake(143, 10)];
    
    self.leftTopLayer.path = aPath.CGPath;
    [self.layer addSublayer:self.leftTopLayer];
    self.leftTopLayer.opacity = 0;
    [self animateLeftTopToStrokeEnd:0];
}
-(void)addRightTopLayer{
    
    self.rightTopLayer = [CAShapeLayer layer];
    self.rightTopLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.rightTopLayer.fillColor = nil;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(161, 5)];
    [aPath addQuadCurveToPoint:CGPointMake(197, 41) controlPoint:CGPointMake(179, 10)];
    
    self.rightTopLayer.path =aPath.CGPath;
    [self.layer addSublayer:self.rightTopLayer];
    self.rightTopLayer.opacity=0;
    [self animateRightTopToStrokeEnd:0];
}

-(void)addLeftBottomLayer{
    self.leftBottomLayer = [CAShapeLayer layer];
    self.leftBottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.leftBottomLayer.fillColor = nil;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(161, 70)];
    [aPath addQuadCurveToPoint:CGPointMake(125, 41) controlPoint:CGPointMake(143, 65)];
    
    self.leftBottomLayer.path =aPath.CGPath;
    [self.layer addSublayer:self.leftBottomLayer];
    self.leftBottomLayer.opacity=0;
    [self animateLeftBottomToStrokeEnd:0];
}

-(void)addRightBottomLayer{
    self.rightBottomLayer = [CAShapeLayer layer];
    self.rightBottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.rightBottomLayer.fillColor = nil;
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(161, 70)];
    [aPath addQuadCurveToPoint:CGPointMake(197, 41) controlPoint:CGPointMake(179, 65)];
    
    self.rightBottomLayer.path =aPath.CGPath;
    [self.layer addSublayer:self.rightBottomLayer];
    self.rightBottomLayer.opacity=0;
    [self animateRightBottomToStrokeEnd:0];
}

#pragma mark animation
- (void)animateToStrokeEnd:(CGFloat)strokeEnd
{
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
}
//set layerA alpha
- (void)animateLayerAtoAlpha:(CGFloat)alphaEnd
{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.squareLayerA pop_addAnimation:opacityAnimation forKey:@"layerAopacityAnimation"];
}
//set layerB alpha
- (void)animateLayerBtoAlpha:(CGFloat)alphaEnd
{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.squarelayerB pop_addAnimation:opacityAnimation forKey:@"layerBopacityAnimation"];
}
//set cricle alpha
- (void)animateToAlphaEnd:(CGFloat)alphaEnd
{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:opacityAnimation forKey:@"circleOpacityAnimation"];
}
//set LeftTopLayer
-(void)animateLeftTopToStrokeEnd:(CGFloat)strokeEnd{
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.leftTopLayer pop_addAnimation:strokeAnimation forKey:@"LeftTopStrokeAnimation"];
}

-(void)animateLeftTopToOpcity:(CGFloat)alphaEnd{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.leftTopLayer pop_addAnimation:opacityAnimation forKey:@"LeftTopOpacityAnimation"];
    
}
//set RightToplayer
-(void)animateRightTopToStrokeEnd:(CGFloat)strokeEnd{
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.rightTopLayer pop_addAnimation:strokeAnimation forKey:@"RightTopStrokeAnimation"];
}

-(void)animateRightTopToOpcity:(CGFloat)alphaEnd{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.rightTopLayer pop_addAnimation:opacityAnimation forKey:@"RightTopOpacityAnimation"];
    
}
//set LeftBottomlayer
-(void)animateLeftBottomToStrokeEnd:(CGFloat)strokeEnd{
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.leftBottomLayer pop_addAnimation:strokeAnimation forKey:@"LeftBomStrokeAnimation"];
}
-(void)animateLeftBottomToOpcity:(CGFloat)alphaEnd{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.leftBottomLayer pop_addAnimation:opacityAnimation forKey:@"LeftBomOpacityAnimation"];
    
}
//set RightBottomlayer
-(void)animateRightBottomToStrokeEnd:(CGFloat)strokeEnd{
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.rightBottomLayer pop_addAnimation:strokeAnimation forKey:@"RightBomStrokeAnimation"];
}
-(void)animateRightBottomToOpcity:(CGFloat)alphaEnd{
    POPSpringAnimation *opacityAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(alphaEnd);
    opacityAnimation.springBounciness = 12.f;
    opacityAnimation.removedOnCompletion = NO;
    [self.rightBottomLayer pop_addAnimation:opacityAnimation forKey:@"RightBomOpacityAnimation"];
    
}
@end
