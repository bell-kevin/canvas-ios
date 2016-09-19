//
//  ModalPresenter.m
//  iCanvas
//
//  Created by Nathan Perry on 3/31/15.
//  Copyright (c) 2015 Instructure. All rights reserved.
//

#import "ModalPresenter.h"
@import Masonry;

static ModalPresenter *_sharedPresenter;

static CGFloat alphaValue = 0.3;

@interface ModalPresenter ()

@property (nonatomic, retain) id<ModalPresentable> presentedController;
@property (nonatomic, copy) void (^completion)();

@end

@implementation ModalPresenter

+(ModalPresenter*) sharedPresenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPresenter = [ModalPresenter new];
    });
    
    return _sharedPresenter;
}

+(void)presentController:(id <ModalPresentable>) presented fromController:(UIViewController*) presentingViewController withCompletion:(void (^)(void))completion{
    [ModalPresenter presentController:presented fromView:presentingViewController.view withCompletion:completion];
}

+(void)presentController:(id<ModalPresentable>)presented fromView:(UIView *)presentingView withCompletion:(void (^)(void))completion{
    ModalPresenter *sharedPresenter = [ModalPresenter sharedPresenter];
    
    // we only support one modal at a time
    [ModalPresenter dismissController];

    
    
    sharedPresenter.presentedController = presented;
    sharedPresenter.completion = completion;
    
    // center the presented view, let it set its own dimensions
    [sharedPresenter.view addSubview:presented.view];
    [sharedPresenter.view addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_sharedPresenter.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:presented.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_sharedPresenter.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:presented.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]
                                           ]];
    [presentingView addSubview:sharedPresenter.view];
    
    // take up the whole view that we are presenting on
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:sharedPresenter.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:presentingView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:sharedPresenter.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:presentingView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:sharedPresenter.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:presentingView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:sharedPresenter.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:presentingView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

+(void)dismissController{
    ModalPresenter *sharedPresenter = [ModalPresenter sharedPresenter];
    for (UIView *sub in sharedPresenter.view.subviews) {
        [sub removeFromSuperview];
    }
    [sharedPresenter.view removeFromSuperview];
    (sharedPresenter.completion) ? sharedPresenter.completion() : nil;
    sharedPresenter.presentedController = nil;
    sharedPresenter.completion = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValue];
}




@end
