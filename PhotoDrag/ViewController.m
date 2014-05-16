//
//  ViewController.m
//  PhotoDrag
//
//  Created by pivotal on 5/15/14.
//  Copyright (c) 2014 Shusta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thatcher"]];
    self.imageView.bounds = (CGRect){.size.width = 200, .size.height = 200};
    self.imageView.center = self.view.center;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
}

@end
