//
//  ViewController.m
//  PhotoDrag
//
//  Created by pivotal on 5/15/14.
//  Copyright (c) 2014 Shusta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicBehavior *parentBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self addImageView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImageView:)];
    twoFingerTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingerTap];

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.imageView];
        UIOffset offset = UIOffsetMake(touchPoint.x - CGRectGetMidX(self.imageView.bounds),
                                       touchPoint.y - CGRectGetMidY(self.imageView.bounds));
        CGPoint point = [sender locationInView:self.imageView.superview];
        
        [self.animator removeAllBehaviors];
        
        self.parentBehavior = [[UIDynamicBehavior alloc] init];
        
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.imageView offsetFromCenter:offset attachedToAnchor:point];
//        self.attachment.frequency = 1;
//        self.attachment.damping = 0.9;
//        self.attachment.length = 0.0;
 
        [self.parentBehavior addChildBehavior:self.attachment];
        
        self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageView]];
        self.itemBehavior.density = 1.0;
        self.itemBehavior.elasticity = 0.7;
        self.itemBehavior.friction = 6;
        self.itemBehavior.resistance = 3.0;
        self.itemBehavior.angularResistance = 3.0;
        
        [self.parentBehavior addChildBehavior:self.itemBehavior];
        [self.animator addBehavior:self.parentBehavior];

        UICollisionBehavior *collisions = [[UICollisionBehavior alloc] initWithItems:@[self.imageView]];
        collisions.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:collisions];

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = [sender locationInView:self.imageView.superview];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.parentBehavior removeChildBehavior:self.attachment];
        CGPoint newVelocity = [sender velocityInView:self.imageView.superview];
        CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.imageView];
        CGPoint delta = {
            .x = newVelocity.x - currentVelocity.x,
            .y = newVelocity.y - currentVelocity.y
        };
        [self.itemBehavior addLinearVelocity:delta forItem:self.imageView];
    }
}

- (void)addImageView {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thatcher"]];
    self.imageView.bounds = (CGRect){.size.width = 160, .size.height = 160};
    self.imageView.center = self.view.center;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(panGesture:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.imageView addGestureRecognizer:panGestureRecognizer];
}

- (void)resetImageView:(id)gestureRecognizer {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    [self.animator removeAllBehaviors];
    [self addImageView];
}

@end
