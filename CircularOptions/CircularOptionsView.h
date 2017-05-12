
//
//  ViewController.h
//  CircularOptions
//
//  Created by Salman Khalid on 06/05/2017.
//  Copyright © 2017 Salman Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CircularOptionsViewDelegate <NSObject>

-(void)OptionsDidLoaded;
-(void)didSelectOption:(int)optionIndex;

@end

@interface CircularOptionsView : UIView

@property (nonatomic, assign) CGFloat progressRingWidth;
@property (nonatomic, assign) NSInteger numberOfSegments;
@property (nonatomic, assign) CGFloat segmentSeparationAngle;
@property (nonatomic) int showTagNumber;
@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) UIColor *secondaryColor;

-(void)SetDelegate:(id)parent;

-(void)PanGestureCurrentPoint:(CGPoint)currentPoint;
-(void)AnimateScaleUp:(BOOL)isScaleUp;

@end
