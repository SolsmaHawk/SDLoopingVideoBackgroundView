// SDLoopingVideoBackgroundView.m
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

#import "SDLoopingVideoBackgroundView.h"
#import <AVFoundation/AVFoundation.h>

static BOOL hasBeenInitialized = NO;

@interface SDLoopingVideoBackgroundView()
@property AVPlayer *avPlayer;
@property AVPlayerItem *avItem;
@end

@implementation SDLoopingVideoBackgroundView

-(instancetype)initWithFrame:(CGRect)frame withPathToResource:(NSString *)path withFiletype:(NSString *)filetype
{
    if(self = [super initWithFrame:frame])
    {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:path ofType:filetype];
        NSURL *videoURL;
        
        if ([[NSBundle mainBundle] URLForResource:path withExtension:filetype])
        {
            videoURL = [NSURL fileURLWithPath:resourcePath];
        }
        else
        {
            NSLog(@"Invalid video path");
            return nil;
        }
        
        AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
        self.clipsToBounds=YES;
        [self setBackgroundColor:[UIColor clearColor]];
        self.opaque = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.avItem  = [AVPlayerItem playerItemWithAsset:videoAsset];
        
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avItem];
        self.avPlayer.muted=YES;
        [self setPlayer:self.avPlayer];
        ((AVPlayerLayer *)[self layer]).videoGravity = AVLayerVideoGravityResizeAspectFill;
        ((AVPlayerLayer *)[self layer]).needsDisplayOnBoundsChange = YES;
        
        __weak typeof(self) weakSelf = self;
        NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
        [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                object:nil
                                 queue:nil
                            usingBlock:^(NSNotification *note) {
                                [weakSelf.avPlayer seekToTime:kCMTimeZero];
                                [weakSelf.avPlayer play];
                            }];
        [noteCenter addObserverForName:UIApplicationWillEnterForegroundNotification
                                object:nil
                                 queue:nil
                            usingBlock:^(NSNotification *note) {
                                [weakSelf.avPlayer seekToTime:kCMTimeZero];
                                [weakSelf.avPlayer play];
                            }];
        if(TARGET_OS_IOS)
        {
            [noteCenter addObserverForName:UIDeviceOrientationDidChangeNotification
                                    object:nil
                                     queue:nil
                                usingBlock:^(NSNotification *note) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [UIView beginAnimations:nil context:nil];
                                        [UIView setAnimationDuration:0.3];
                                        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                                        weakSelf.frame = weakSelf.superview.frame;
                                        [UIView commitAnimations];
                                    });
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [UIView beginAnimations:nil context:nil];
                                            [UIView setAnimationDuration:0.3];
                                            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                                            weakSelf.frame = weakSelf.superview.frame;
                                            [UIView commitAnimations];
                                        });
                                    });
                                }];
        }
        
        @try
        {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@", exception.reason);
        }
        
        hasBeenInitialized = YES;
        [self.avPlayer play];
        return self;
    }
    return nil;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (void)dealloc
{
    if (hasBeenInitialized)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

-(void)play
{
    [self.avPlayer play];
}

-(void)setVideoPlayerMuted:(BOOL)muted
{
    self.avPlayer.muted=muted;
}

-(void)pause
{
    [self.avPlayer pause];
}

@end
