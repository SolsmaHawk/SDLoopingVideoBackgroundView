// ViewController.m
//
// Created by John Solsma
// Copyright (c) 2017 SolsmaDev Inc. http://SolsmaDev.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ViewController.h"
#import "SDLoopingVideoBackgroundView.h"
@interface ViewController ()
@property SDLoopingVideoBackgroundView *videoBackground;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoBackground = [[SDLoopingVideoBackgroundView alloc] initWithFrame:self.view.frame withPathToResource:@"sampleVid" withFiletype:@"mp4"];
    [self.view addSubview:self.videoBackground];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.videoBackground.center = self.view.center;
    self.videoBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
   // self.videoBackground.frame = self.view.bounds;
  
}


@end
