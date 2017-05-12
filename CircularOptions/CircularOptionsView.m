//
//  ViewController.h
//  CircularOptions
//
//  Created by Salman Khalid on 06/05/2017.
//  Copyright © 2017 Salman Khalid. All rights reserved.
//

#import "CircularOptionsView.h"

@interface CircularOptionsView () <CAAnimationDelegate>

@property (nonatomic, retain) CAShapeLayer *touchesDetectionLayer;
@property (nonatomic, retain) CAShapeLayer *selectedSegmentLayer;

@end


@implementation CircularOptionsView
{
    CGFloat outerRingAngle;
    CGFloat innerRingAngle;
    CGFloat segmentSeparationInnerAngle;
    
    id<CircularOptionsViewDelegate> delegate;
    NSMutableArray *segmentsPointsArray;
}

#pragma mark Initalization and setup

-(void)SetDelegate:(id)parent {
    
    delegate = parent;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addObserver:self forKeyPath:@"showTagNumber" options:NSKeyValueObservingOptionNew context:nil];
    
    self.showTagNumber = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.progressRingWidth = fmaxf(self.bounds.size.width * .35, 1.0);

    self.numberOfSegments = 10;
    self.segmentSeparationAngle = M_PI / (16 * self.numberOfSegments);
    
    [self updateAngles];
    
    self.primaryColor = [UIColor greenColor];
    self.secondaryColor = [UIColor colorWithRed:90.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    self.touchesDetectionLayer = [CAShapeLayer layer];
    self.touchesDetectionLayer.fillColor = [UIColor clearColor].CGColor;
    self.touchesDetectionLayer.strokeColor = self.primaryColor.CGColor;
    
    self.selectedSegmentLayer = [CAShapeLayer layer];
    [self.selectedSegmentLayer setFillColor:self.secondaryColor.CGColor];
    
    [self.layer addSublayer:self.touchesDetectionLayer];
    [self.layer addSublayer:self.selectedSegmentLayer];
    
    segmentsPointsArray = [[NSMutableArray alloc] init];
    
    [self AnimateScaleUp:false];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"showTagNumber"]){
        
        [delegate didSelectOption:self.showTagNumber];
    }
}

#pragma mark Layout


- (CGSize)intrinsicContentSize
{
    CGFloat base = _progressRingWidth * 2;
    return CGSizeMake(base, base);
}

- (void)updateAngles
{
    outerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - _segmentSeparationAngle;
    segmentSeparationInnerAngle = 2.0 * asinf(((self.bounds.size.width / 2.0) * sinf(_segmentSeparationAngle / 2.0)) / ((self.bounds.size.width / 2.0) - _progressRingWidth));
    innerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - segmentSeparationInnerAngle;
}

- (NSInteger)numberOfFullSegments
{
    return _numberOfSegments;
}

#pragma mark Drawing

- (void)drawTouchesLayer    {
    
    CGFloat outerStartAngle = - M_PI_2 * 0.8;
    outerStartAngle += (_segmentSeparationAngle / 2.0);
    CGFloat innerStartAngle = - M_PI_2  * 0.8;
    innerStartAngle += (segmentSeparationInnerAngle / 2.0) + innerRingAngle;
    [segmentsPointsArray removeAllObjects];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    for (int i = 0; i < [self numberOfFullSegments]; i++) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width / 2.0) startAngle:outerStartAngle endAngle:(outerStartAngle + outerRingAngle) clockwise:YES];
        [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - (_progressRingWidth / 4.0f) startAngle:(outerStartAngle + outerRingAngle) endAngle:outerStartAngle clockwise:NO];
        [path closePath];
        
        CGFloat midPointAngle = (innerStartAngle + outerStartAngle) / 2.0;
        CGPoint midPoint = CGPointMake((center.x + ((self.bounds.size.width / 2.0) - _progressRingWidth/8.0f) * cos(midPointAngle)), center.y + ((self.bounds.size.width / 2.0) - _progressRingWidth/8.0f) * sin(midPointAngle));
        
        [self AddButtonAtPoint:midPoint forTag:i];
        
        NSString *tagString = [NSString stringWithFormat:@"%i",i];
        NSString *XString = [NSString stringWithFormat:@"%f",midPoint.x];
        NSString *YString = [NSString stringWithFormat:@"%f",midPoint.y];
        
        [segmentsPointsArray addObject:@{@"path":path,@"tag":tagString,@"X":XString,@"Y":YString}];
        
        CGPathAddPath(pathRef, NULL, path.CGPath);
        
        outerStartAngle += (outerRingAngle + _segmentSeparationAngle);
        innerStartAngle += (innerRingAngle + segmentSeparationInnerAngle);
    }
    
    _touchesDetectionLayer.path = pathRef;
    
    CGPathRelease(pathRef);
    
}

-(void)AddButtonAtPoint:(CGPoint)point forTag:(int)i    {
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[NSString stringWithFormat:@"%i",i]];
    [lbl setCenter:point];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbl];
}

- (void)drawSelectedLayer    {
    
    CGFloat outerStartAngle = - M_PI_2 * 0.8;
    outerStartAngle += (_segmentSeparationAngle / 2.0);
    CGFloat innerStartAngle = - M_PI_2 * 0.8;
    innerStartAngle += (segmentSeparationInnerAngle / 2.0) + innerRingAngle;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    
    for (int i = 0; i < [self numberOfFullSegments]; i++) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width / 2.0) startAngle:outerStartAngle endAngle:(outerStartAngle + outerRingAngle) clockwise:YES];
        [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - (_progressRingWidth/4) startAngle:(outerStartAngle + outerRingAngle) endAngle:outerStartAngle clockwise:NO];
        [path closePath];
        
        if(self.showTagNumber == i)
        {
            CGPathAddPath(pathRef, NULL, path.CGPath);
            break;
        }
        outerStartAngle += (outerRingAngle + _segmentSeparationAngle);
        innerStartAngle += (innerRingAngle + segmentSeparationInnerAngle);
    }

    _selectedSegmentLayer.path = pathRef;
    CGPathRelease(pathRef);
    
}
- (void)drawRect:(CGRect)rect   {
    
    [self drawTouchesLayer];
    [self drawSelectedLayer];
    
    [super drawRect:rect];
    
}

-(void)PanGestureCurrentPoint:(CGPoint)currentPoint
{
    for (NSDictionary *tempDict in segmentsPointsArray)
    {
        UIBezierPath *path = [tempDict objectForKey:@"path"];        
        if([path containsPoint:currentPoint])
        {
            self.showTagNumber = [[tempDict objectForKey:@"tag"] intValue];
            [self setNeedsDisplay];
        }
    }
}

#pragma mark -
#pragma mark Animation

-(void)AnimateScaleUp:(BOOL)isScaleUp    {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.duration = 0.2;
    anim.repeatCount = 0;
    anim.autoreverses = NO;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    if(isScaleUp)
    {
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        [self.layer addAnimation:anim forKey:@"ScaleUp"];
    }
    else
    {
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        [self.layer addAnimation:anim forKey:@"ScaleDown"];
    }
}

@end
