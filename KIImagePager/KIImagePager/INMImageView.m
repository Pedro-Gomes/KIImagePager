//
//  INMImageView.m
//  Public
//
//  Created by Marlon Tojal on 29/04/14.
//  Copyright (c) 2014 Innovation Makers. All rights reserved.
//

#import "INMImageView.h"

@interface INMImageView()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int currentIndex;
@end

@implementation INMImageView

-(void)dealloc{
    self.timer = nil;
}

-(void)startAnimating{
    if (self.animationImages.count > 1) {
        [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(performTransition) userInfo:nil repeats:YES];
    }
}

-(void)stopAnimating{
    self.timer = nil;
}

-(void)performTransition {
    self.currentIndex = (self.currentIndex + 1) % self.animationImages.count;
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(){
        [self setImage:[self.animationImages objectAtIndex:self.currentIndex]];
    } completion:nil];
}

@end
