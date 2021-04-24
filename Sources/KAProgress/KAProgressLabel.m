//
//  KAProgressLabel.m
//  KAProgressLabel
//
//  Created by Alex on 09/06/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KAProgressLabel.h"

#define KADegreesToRadians(degrees) ((degrees)/180.0*M_PI)
#define KARadiansToDegrees(radians) ((radians)*180.0/M_PI)

@implementation KAProgressLabel {
    TPPropertyAnimation *_currentStartDegreeAnimation;
    TPPropertyAnimation *_currentEndDegreeAnimation;
}

@synthesize startDegree = _startDegree;
@synthesize endDegree = _endDegree;
@synthesize progress = _progress;

#pragma mark Core

-(void)dealloc
{
    // KVO
    [self removeObserver:self forKeyPath:@"trackWidth"];
    [self removeObserver:self forKeyPath:@"borderWidth"];
    [self removeObserver:self forKeyPath:@"progressWidth"];
    [self removeObserver:self forKeyPath:@"fillColor"];
    [self removeObserver:self forKeyPath:@"trackColor"];
    [self removeObserver:self forKeyPath:@"borderColor"];
    [self removeObserver:self forKeyPath:@"progressColor"];
    [self removeObserver:self forKeyPath:@"startDegree"];
    [self removeObserver:self forKeyPath:@"endDegree"];
    [self removeObserver:self forKeyPath:@"endRoundedCornersWidth"];
    [self removeObserver:self forKeyPath:@"startRoundedCornersWidth"];
    
    [self removeObserver:self forKeyPath:@"startView"];
    [self removeObserver:self forKeyPath:@"endView"];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit
{
    // Logic
    _startDegree        = 0;
    _endDegree          = 0;
    _progress           = 0;
    
    // We need a square view
    // For now, we resize  and center the view
    if(self.frame.size.width != self.frame.size.height){
        CGRect frame = self.frame;
        float delta = ABS(self.frame.size.width-self.frame.size.height)/2;
        if(self.frame.size.width > self.frame.size.height){
            frame.origin.x += delta;
            frame.size.width = self.frame.size.height;
            self.frame = frame;
        }else{
            frame.origin.y += delta;
            frame.size.height = self.frame.size.width;
            self.frame = frame;
        }
    }
    [self setUserInteractionEnabled:YES];
    
    // Style
    self.textAlignment = NSTextAlignmentCenter;
    _trackWidth             = 5.0;
    _borderWidth            = 0.0;
    _progressWidth          = 5.0;
    _startRoundedCornersWidth   = 0.0;
    _endRoundedCornersWidth     = 0.0;
    _fillColor              = [UIColor clearColor];
    _trackColor             = [UIColor lightGrayColor];
    _borderColor            = [UIColor clearColor];
    _progressColor          = [UIColor blackColor];
	
    
    [self addObservers];
}

- (void)addObservers {
    // KVO
    [self addObserver:self forKeyPath:@"trackWidth"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"borderWidth"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"progressWidth"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"fillColor"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"borderColor"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"trackColor"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"progressColor"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"startDegree"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"endDegree"                    
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"endRoundedCornersWidth"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"startRoundedCornersWidth"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"startView"
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"endView"
              options:NSKeyValueObservingOptionNew context:nil];
}

-(void)drawRect:(CGRect)rect
{
    [self drawProgressLabelCircleInRect:self.bounds];
    [super drawTextInRect:self.bounds];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self setNeedsDisplay] ;
    
    if([keyPath isEqualToString:@"startDegree"] ||
       [keyPath isEqualToString:@"endDegree"]){
        
        KAProgressLabel *__unsafe_unretained weakSelf = self;
        if(self.labelVCBlock) {
            self.labelVCBlock(weakSelf);
        }
    }
}

#pragma mark - Getters

- (float) radius
{
    return MIN(self.frame.size.width,self.frame.size.height)/2;
}

- (CGFloat)startDegree
{
    return _startDegree +90;
}

- (CGFloat)endDegree
{
    return _endDegree +90;
}

- (CGFloat)progress
{
    return self.endDegree/360;
}

#pragma mark - Setters

-(void)setStartDegree:(CGFloat)startDegree
{
    _startDegree = startDegree - 90;
}

-(void)setEndDegree:(CGFloat)endDegree
{
    _endDegree = endDegree - 90;
}

-(void)setProgress:(CGFloat)progress
{
    if(self.startDegree != 0){
        self.startDegree = 0;
    }
    self.endDegree = progress*360;
}

- (void)setStartView:(UIView *)startView {
	[_startView removeFromSuperview];
	_startView = startView;
	[self addSubview:startView];
}

- (void)setEndView:(UIView *)endView {
	[_endView removeFromSuperview];
	_endView = endView;
	[self addSubview:endView];
}

#pragma mark - Animations

-(void)setStartDegree:(CGFloat)startDegree timing:(TPPropertyAnimationTiming)timing duration:(CGFloat)duration delay:(CGFloat)delay
{
    TPPropertyAnimation *animation = [TPPropertyAnimation propertyAnimationWithKeyPath:@"startDegree"];
    animation.delegate = self;
    animation.fromValue = @(_startDegree+90);
    animation.toValue = @(startDegree);
    animation.duration = duration;
    animation.startDelay = delay;
    animation.timing = timing;
    [animation beginWithTarget:self];
    
    _currentStartDegreeAnimation = animation;
}

-(void)setEndDegree:(CGFloat)endDegree timing:(TPPropertyAnimationTiming)timing duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)())completionBlock
{
    TPPropertyAnimation *animation = [TPPropertyAnimation propertyAnimationWithKeyPath:@"endDegree"];
	animation.completion = completionBlock;
	animation.fromValue = @(_endDegree+90);
    animation.toValue = @(endDegree);
    animation.duration = duration;
    animation.startDelay = delay;
    animation.timing = timing;
    [animation beginWithTarget:self];
	
    _currentEndDegreeAnimation = animation;
}

-(void)setProgress:(CGFloat)progress timing:(TPPropertyAnimationTiming)timing duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)())completionBlock;
{
	__weak typeof(self) welf = self;
	[self setEndDegree:(progress*360) timing:timing duration:duration delay:delay completion:^{
		NSArray *animations = [TPPropertyAnimation allPropertyAnimationsForTarget:welf];
		_isAnimating = animations.count == 1;
		completionBlock();
	}];
}

- (void) stopAnimations
{
    if (_currentStartDegreeAnimation != nil) {
        [_currentStartDegreeAnimation cancel];
        _currentStartDegreeAnimation = nil;
    }
    if (_currentEndDegreeAnimation != nil) {
        [_currentEndDegreeAnimation cancel];
        _currentEndDegreeAnimation = nil;
    }
}


- (void)propertyAnimationDidFinish:(TPPropertyAnimation*)propertyAnimation
{
    _currentStartDegreeAnimation = nil;
    _currentEndDegreeAnimation = nil;
}

#pragma mark - Touch Interaction

// Limit touch to actual disc surface
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    return  ([p containsPoint:point])? self : nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self moveBasedOnTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self moveBasedOnTouches:touches withEvent:event];
}

- (void)moveBasedOnTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    // No interaction enabled
    if(!self.isStartDegreeUserInteractive &&
       !self.isEndDegreeUserInteractive){
        return;
    }
    
    UITouch * touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    // Coordinates to polar
    float x = touchLocation.x - self.frame.size.width/2;
    float y = touchLocation.y - self.frame.size.height/2;
    int angle = KARadiansToDegrees(atan(y/x));
    angle += (x>=0)?  90 : 270;
    
    // Interact
    if(!self.isStartDegreeUserInteractive) // Only End
    {
        self.endDegree = angle;
    }
    else if(!self.isEndDegreeUserInteractive) // Only Start
    {
        self.startDegree = angle;
    }
    else // All,hence move nearest knob
    {
        float startDelta = sqrt(pow(self.startView.center.x-touchLocation.x,2) + pow(self.startView.center.y- touchLocation.y,2));
        float endDelta = sqrt(pow(self.endView.center.x-touchLocation.x,2) + pow(self.endView.center.y - touchLocation.y,2));
        if(startDelta<endDelta){
            self.startDegree = angle;
        }else{
            self.endDegree = angle;
        }
    }
}

#pragma mark - Drawing

-(void)drawProgressLabelCircleInRect:(CGRect)rect
{
    CGRect circleRect= [self rectForCircle:rect];
    CGFloat archXPos = (rect.size.width-(2*_borderWidth))/2 + rect.origin.x;
    CGFloat archYPos = (rect.size.width-(2*_borderWidth))/2 + rect.origin.y;
    CGFloat archRadius = (circleRect.size.width - (2*_borderWidth)) / 2.0;
    
    int clockwise = 0;
    if (self.progress < 0.0f) {
        clockwise = 1;
    }
    
    CGFloat trackStartAngle = KADegreesToRadians(0);
    CGFloat trackEndAngle = KADegreesToRadians(360);
    CGFloat progressStartAngle = KADegreesToRadians(_startDegree);
    CGFloat progressEndAngle = KADegreesToRadians(_endDegree);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Circle
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokePath(context);
    
    // Border Track
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, _trackWidth+_borderWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, trackStartAngle, trackEndAngle, 1);
    CGContextStrokePath(context);
    
    // Track
    CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor);
    CGContextSetLineWidth(context, _trackWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, trackStartAngle, trackEndAngle, 1);
    CGContextStrokePath(context);
    
    // Progress
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextSetLineWidth(context, _progressWidth);
    CGContextAddArc(context, archXPos, archYPos, archRadius, progressStartAngle, progressEndAngle, clockwise);
    CGContextStrokePath(context);
    
    float diminish = 6.5;
	
	CGRect startRect = [self rectForDegree:_startDegree andRect:rect andCornerWitdh:_startRoundedCornersWidth];
    // Rounded corners
    if (_startRoundedCornersWidth > 0 && self.progress != 0.0f) {
        CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        CGContextAddEllipseInRect(context, startRect);
        CGContextFillPath(context);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectInset(startRect, startRect.size.width/diminish, startRect.size.height/diminish));
        CGContextFillPath(context);
    }
	
	CGRect endRect = [self rectForDegree:_endDegree andRect:rect andCornerWitdh:_endRoundedCornersWidth];
    if (_endRoundedCornersWidth > 0 && self.progress!= 0.0f) {
        CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        CGContextAddEllipseInRect(context, endRect);
        CGContextFillPath(context);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectInset(endRect, endRect.size.width/diminish, endRect.size.height/diminish));
        CGContextFillPath(context);
    }
	
	
	self.startView.center =  CGPointMake(CGRectGetMidX(startRect), CGRectGetMidY(startRect));
	self.endView.center =  CGPointMake(CGRectGetMidX(endRect), CGRectGetMidY(endRect));
    self.startView.layer.cornerRadius = [self borderDeltaWithCornerWitdth:_startRoundedCornersWidth];
    self.endView.layer.cornerRadius = [self borderDeltaWithCornerWitdth:_endRoundedCornersWidth];
}

#pragma mark - Helpers

- (CGRect)rectForDegree:(float)degree andRect:(CGRect)rect andCornerWitdh:(float)corenerWidth
{
    float x = [self xPosRoundForAngle:degree andRect:rect andCornerWitdh:corenerWidth] - corenerWidth/2 - 2 * self.borderWidth;
    float y = [self yPosRoundForAngle:degree andRect:rect andCornerWitdh:corenerWidth] - corenerWidth/2 - 2 * self.borderWidth;
    
    return CGRectMake(x, y, corenerWidth, corenerWidth);
}

- (float)xPosRoundForAngle:(float)degree andRect:(CGRect)rect andCornerWitdh:(float)corenerWidth
{
    return cosf(KADegreesToRadians(degree))* [self radius]
    - cosf(KADegreesToRadians(degree)) * [self borderDeltaWithCornerWitdth:corenerWidth]
    - cosf(KADegreesToRadians(degree)) * 2 * self.borderWidth
    + rect.size.width/2;
}

- (float)yPosRoundForAngle:(float)degree andRect:(CGRect)rect andCornerWitdh:(float)corenerWidth
{
    return sinf(KADegreesToRadians(degree))* [self radius]
    - sinf(KADegreesToRadians(degree)) * [self borderDeltaWithCornerWitdth:MAX(_endRoundedCornersWidth, _startRoundedCornersWidth)]
    - sinf(KADegreesToRadians(degree)) * 2 * self.borderWidth
    + rect.size.height/2 ;
}

- (float) borderDeltaWithCornerWitdth:(float)corenerWidth
{
    return MAX(MAX(_trackWidth+_borderWidth,_progressWidth),corenerWidth)/2;
}

-(CGRect)rectForCircle:(CGRect)rect
{
    CGFloat minDim = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat circleRadius = (minDim/ 2) - [self borderDeltaWithCornerWitdth:MAX(_endRoundedCornersWidth, _startRoundedCornersWidth)];
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return CGRectMake(circleCenter.x - circleRadius, circleCenter.y - circleRadius, 2 * circleRadius, 2 * circleRadius);
}

@end
