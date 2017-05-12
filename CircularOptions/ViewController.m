//
//  ViewController.m
//  CircularOptions
//
//  Created by Salman Khalid on 06/05/2017.
//  Copyright © 2017 Salman Khalid. All rights reserved.
//

#import "ViewController.h"
#import "CircularOptionsView.h"

@interface ViewController ()<CircularOptionsViewDelegate> {
    
    BOOL panEnabled;
}

@property (weak, nonatomic) IBOutlet CircularOptionsView *presetBGLayerView;
@property (weak, nonatomic) IBOutlet UIView *gesturesRecoginzerView;
@property (weak, nonatomic) IBOutlet UILabel *optionsSelectedlbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    panEnabled = false;
    [self.presetBGLayerView SetDelegate:self];
}

- (IBAction)panning:(id)sender {
    
    if (panEnabled) {
    
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        
        if (pan.state == UIGestureRecognizerStateChanged) {
            
            [self.presetBGLayerView PanGestureCurrentPoint:[pan locationInView:self.gesturesRecoginzerView]];
            
        }
    }
}


-(IBAction)LongPress:(id)sender
{

    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self ShowOptionsButtons];
            panEnabled = YES;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            [self HideOptionsButtons];
            panEnabled = NO;
            [self.presetBGLayerView setNeedsDisplay];
            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)ShowOptionsButtons {
    
    [self.presetBGLayerView AnimateScaleUp:true];
}

-(void)HideOptionsButtons    {

    [self.presetBGLayerView AnimateScaleUp:false];
    
}

#pragma mark -
#pragma mark CircularOptionsViewDelegate

-(void)OptionsDidLoaded {
}

-(void)didSelectOption:(int)optionIndex  {
    
    self.optionsSelectedlbl.text = [NSString stringWithFormat:@"%i",optionIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
