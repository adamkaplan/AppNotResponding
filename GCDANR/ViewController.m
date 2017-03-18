//
//  ViewController.m
//  GCDANR
//
//  Created by Adam Kaplan on 3/13/17.
//  Copyright © 2017 Adam Kaplan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UIStackView *stackView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:@[ [self buttonWithSleepInterval:0.2],
                                                                      [self buttonWithSleepInterval:0.8],
                                                                      [self buttonWithSleepInterval:1.0],
                                                                      [self buttonWithSleepInterval:1.5],
                                                                      [self buttonWithSleepInterval:1.6],
                                                                      [self buttonWithSleepInterval:2.0],
                                                                      [self buttonWithSleepInterval:2.5],
                                                                      [self buttonWithSleepInterval:4.0]
                                                                      ]];
    
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    [self.view addSubview:self.stackView];
    
    [self.stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (UIButton *)buttonWithSleepInterval:(NSTimeInterval)sleepInterval {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = sleepInterval * 1000;
    [button setTitle:[NSString stringWithFormat:@"Sleep %.0fms", sleepInterval * 1000] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sleep:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)sleep:(UIButton *)button {
    button.enabled = NO;
    NSLog(@"sleep start");
    
    [NSThread sleepForTimeInterval:button.tag / 1000.0];
    
    NSLog(@"sleep end");
    button.enabled = YES;
}

@end
