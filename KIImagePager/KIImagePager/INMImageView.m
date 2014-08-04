//
//  INMImageView.m
//  Public
//
//  Created by Marlon Tojal on 29/04/14.
//  Copyright (c) 2014 Innovation Makers. All rights reserved.
//

#import "INMImageView.h"

#define SPINNER_TAG 201
#define FAILURE_TAG 202

@interface UIView(Additions)
+(void)startSpinAnimationOnView:(UIView *)view
                       duration:(CGFloat)duration
                      rotations:(CGFloat)rotations
                         repeat:(float)repeat;
+(void)stopSpinAnimationOnView:(UIView *)view;
@end

@interface INMImageView()

@property (nonatomic, strong) NSArray* images;
@property (nonatomic) int currentIndex;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
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
    if (self.animationImages.count > 0) {
        [self loadImageAtIndex:0];
    } else {
        [self setImage:self.placeholderImage];
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
            [self loadImageAtIndex:self.currentIndex];
        } completion:^(BOOL completion){
            [self startAnimating];
        }];
    }

}

-(void)loadImageAtIndex:(NSInteger)index{
    [self loadImage:[self.images objectAtIndex:index]
        placeholder:self.placeholderImage
    failPlaceholder:self.placeHolderOverlayForFailure
       animationImg:self.placeHolderSpinnerForLoad
            animate:YES];
    
    
//    if (self.placeHolderOverlayForFailure ||
//        self.placeHolderSpinnerForLoad) {
//        [self loadImage:[self.images objectAtIndex:index]
//            placeholder:self.placeholderImage
//        failPlaceholder:self.placeHolderOverlayForFailure
//           animationImg:self.placeHolderSpinnerForLoad
//                animate:YES];
//    } else {
//        [self loadImage:[self.images firstObject]];
//    }
}

-(void)loadImage:(NSString *)imageURL
     placeholder:(UIImage *)placeholder
 failPlaceholder:(UIImage *)failPlaceholder
    animationImg:(UIImage *)animationImg
         animate:(BOOL)animate {
    /**STEP 1 CLEAR EXTRA SUBVIEWS**/
    UIView* removable;
    /*REMOVE SPINNER*/
    removable = [self viewWithTag:SPINNER_TAG];
    if(removable) {
        if (animate) {
            [UIView stopSpinAnimationOnView:removable];
        }
        [removable removeFromSuperview];
    }
    /*REMOVE FAILURE (just in case)*/
    removable = [self viewWithTag:FAILURE_TAG];
    
    
    
    /**STEP 2 CREATE SPINNER**/
    UIImageView* spinner;
    if (animationImg) {
        spinner = [[UIImageView alloc] initWithFrame:self.bounds];
        [spinner setContentMode:UIViewContentModeCenter];
        [spinner setImage:animationImg];
        [spinner setTag:SPINNER_TAG];
        [self addSubview:spinner];
    }
    /*Animated?*/
    if(animate) {
        [UIView startSpinAnimationOnView:spinner
                                duration:0.5
                               rotations:1
                                  repeat:CGFLOAT_MAX];
    }
    [self setContentMode:UIViewContentModeCenter];
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pictureshack.us/images/85982_dks2_majula_01_small.jpg"]]
                placeholderImage:self.placeholderImage
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             [self setImage:image];
                             UIView* removable;
                             /*REMOVE SPINNER*/
                             removable = [self viewWithTag:SPINNER_TAG];
                             if(removable) {
                                 if (animate) {
                                     [UIView stopSpinAnimationOnView:removable];
                                 }
                                 [removable removeFromSuperview];
                             }
                             /*REMOVE FAILURE (just in case)*/
                             removable = [self viewWithTag:FAILURE_TAG];
                             [self setContentMode:self.contentModeForSuccess];
                         }
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             
                             [self setImage:self.placeholderImage];
                             UIView* removable;
                             /*REMOVE SPINNER*/
                             removable = [self viewWithTag:SPINNER_TAG];
                             if(removable) {
                                 if (animate) {
                                     [UIView stopSpinAnimationOnView:removable];
                                 }
                                 [removable removeFromSuperview];
                             }
                             /*ADD FAILURE*/
                             UIImageView* failImage = [[UIImageView alloc] initWithFrame:self.bounds];
                             [failImage setContentMode:UIViewContentModeCenter];
                             [failImage setImage:failPlaceholder];
                             [failImage setTag:FAILURE_TAG];
                             [self addSubview:failImage];
                         }];
    
}

@end
