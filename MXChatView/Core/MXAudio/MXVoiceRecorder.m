//
//  MXVoiceRecorder.m
//
//  Created by longminxiang on 14-4-1.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXVoiceRecorder.h"
#import "MXVoiceHub.h"
#import <AVFoundation/AVFoundation.h>

#define WAVE_UPDATE_FREQUENCY   0.05

@interface MXVoiceRecorder ()

@property (nonatomic, readonly) NSString *recordPath;
@property (nonatomic, assign) float recordTime;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation MXVoiceRecorder

+ (instancetype)sharedRecorder
{
    static id object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{object = [self new];});
    return object;
}

- (id)init
{
    if (self = [super init]) {
        _recordPath = [NSString stringWithFormat:@"%@tempSound", NSTemporaryDirectory()];
        
        NSError *err = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];

        NSURL *url = [NSURL fileURLWithPath:self.recordPath];
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        
        if(audioData) {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[url path] error:&err];
        }
        err = nil;
        NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
    }
    return self;
}

#pragma mark 
#pragma mark === action ===

- (void)startRecord
{
    [self.recorder record];
    [MXVoiceHub show];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    }
    [self.timer fire];
}

- (void)stopRecord
{
    [MXVoiceHub hide];
    [self.recorder stop];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)stopRecord:(void (^)(NSString *voicePath, float voiceTime))completion
{
    [self stopRecord];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) completion(self.recordPath, self.recordTime);
        self.recordTime = 0;
    });
}

- (void)cancelled
{
    [self stopRecord];
    self.recordTime = 0;
}

#pragma mark - Timer Update

- (void)updateMeters
{
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    [self.recorder updateMeters];
    float peakPower = [self.recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    [MXVoiceHub setProgress:peakPowerForChannel];
}

- (void)dealloc
{
    [self stopRecord];
}

@end
