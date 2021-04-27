//
//  KAProgressLabel.h
//  KAProgressLabel
//
//  Created by Alex on 09/06/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "TPPropertyAnimation.h"

@class KAProgressLabel;
typedef void(^labelValueChangedCompletion)(KAProgressLabel *label);



IB_DESIGNABLE
@interface KAProgressLabel : UILabel

@property (nonatomic, copy) labelValueChangedCompletion labelVCBlock;

// Style
@property (nonatomic) IBInspectable CGFloat trackWidth;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat progressWidth;
@property (nonatomic) IBInspectable CGFloat endRoundedCornersWidth;
@property (nonatomic) IBInspectable CGFloat startRoundedCornersWidth;

@property (nonatomic, copy) IBInspectable UIColor * fillColor;
@property (nonatomic, copy) IBInspectable UIColor * trackColor;
@property (nonatomic, copy) IBInspectable UIColor * progressColor;
@property (nonatomic, copy) IBInspectable UIColor * borderColor;
@property (nonatomic, strong) UIView * startView;
@property (nonatomic, strong) UIView * endView;

// Logic
@property (nonatomic, assign) IBInspectable CGFloat startDegree;
@property (nonatomic, assign) IBInspectable CGFloat endDegree;
@property (nonatomic, assign) IBInspectable CGFloat progress;

// Interactivity
@property (nonatomic, assign) BOOL isStartDegreeUserInteractive;
@property (nonatomic, assign) BOOL isEndDegreeUserInteractive;

@property (nonatomic, assign) BOOL isAnimating;

// Getters
- (float)radius;

// Animations
- (void)setStartDegree:(CGFloat)startDegree
               timing:(TPPropertyAnimationTiming)timing
             duration:(CGFloat)duration
                delay:(CGFloat)delay;

- (void)setEndDegree:(CGFloat)endDegree
             timing:(TPPropertyAnimationTiming)timing
           duration:(CGFloat)duration
              delay:(CGFloat)delay
		  completion:(void (^)())completionBlock;

-(void)setProgress:(CGFloat)progress
			timing:(TPPropertyAnimationTiming)timing
		  duration:(CGFloat)duration
			 delay:(CGFloat)delay
		completion:(void (^)())completionBlock;

- (void)stopAnimations;
@end
