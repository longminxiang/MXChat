//
//  MXVoiceRecorder.m
//
//  Created by longminxiang on 14-4-1.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXVoiceRecorder.h"
#import "MXVoiceHub.h"
#import <AVFoundation/AVFoundation.h>
#import <lame/lame.h>

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
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
    }
    return self;
}

- (NSString *)audio_PCMtoMP3
{
    NSString *mp3Path = [NSString stringWithFormat:@"%@tmp.mp3", NSTemporaryDirectory()];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([self.recordPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    return mp3Path;
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *newPath = [self audio_PCMtoMP3];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(newPath, self.recordTime);
            self.recordTime = 0;
        });
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
