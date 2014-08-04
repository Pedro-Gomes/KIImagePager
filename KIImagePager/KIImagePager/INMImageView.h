//
//  INMImageView.h
//  Public
//
//  Created by Marlon Tojal on 29/04/14.
//  Copyright (c) 2014 Innovation Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INMImageViewDelegate <NSObject>

@optional
-(void)didRestartAnimation:(UIImageView *)imageView;

@end

@interface INMImageView : UIImageView
    @property (nonatomic, strong) UIImage *placeholderImage;
    @property (nonatomic, strong) UIImage *placeHolderOverlayForFailure;
    @property (nonatomic, strong) UIImage *placeHolderSpinnerForLoad;
    @property (nonatomic, weak) id<INMImageViewDelegate> delegate;
    @property (nonatomic) UIViewContentMode contentModeForSuccess;

    -(void)stopAnimating;
@end
