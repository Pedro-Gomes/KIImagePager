//
//  INMImageView.m
//  Public
//
//  Created by Marlon Tojal on 29/04/14.
//  Copyright (c) 2014 Innovation Makers. All rights reserved.
//

#import "INMImageView.h"

@interface INMImageView()

@property (nonatomic, strong) NSArray* images;
@property (nonatomic) int currentIndex;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;
@end

@implementation INMImageView

-(void)dealloc{
    NSLog(@"DEALLOC:%p --> %d", self , self.tag);
    [self stopAnimating];
    self.delegate = nil;
}

-(NSArray *)animationImages{
    return self.images;
}

-(void)setAnimationImages:(NSArray *)animationImages{
    _images = animationImages;
    if (self.animationImages.count > 0){
        [self loadImage:[animationImages firstObject]];
    }
}

-(void)loadImage:(NSString *)imageURL{
    [self setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.placeholderImage];
}

-(void)startAnimating{
    [self performSelector:@selector(performTransition) withObject:nil afterDelay:self.animationDuration];
    NSLog(@"Starting animation for image %d %@", self.tag, [NSDate date]);
}

-(void)stopAnimating{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)performTransition {
    
    NSLog(@"%p --> %d", self , self.tag);
    
    if (self.animationImages.count > 0){
        self.currentIndex =  (self.currentIndex + 1) % self.animationImages.count;
    }
    
    NSLog(@"IDX:%d", self.currentIndex);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRestartAnimation:)] && self.currentIndex == 0) {
        [self stopAnimating];
        NSLog(@"Called delegate for image %d", self.tag);
        NSLog(@"-----------------------------");
        [self.delegate didRestartAnimation:self];
    } else if (self.animationImages.count > 1) {
        NSLog(@"Firing animation for image %d %@", self.tag, [NSDate date]);
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(){
            [self loadImage:[self.animationImages objectAtIndex:self.currentIndex]];
        } completion:^(BOOL completion){
            [self startAnimating];
        }];
    }

}

@end
