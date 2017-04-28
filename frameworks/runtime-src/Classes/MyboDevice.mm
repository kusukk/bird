//
//  MyboDevice.m
//  bird
//
//  Created by 彭先锋 on 2017/4/28.
//
//

#import <Foundation/Foundation.h>
#include "MyboDevice.h"
#include "SoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer *audioSourcePlayer = nullptr;
static bool _stoppedMilleuBgMusic= false;
static bool _pauseMilleuBgMusic= false;

void MyboDevice::playMilieuBgMusic(const std::string musicName,bool loop){
    MyboDevice::proloadMilleuBgMusic(musicName);
    audioSourcePlayer.numberOfLoops = loop?-1:0;
    if (!_stoppedMilleuBgMusic && !_pauseMilleuBgMusic) {
        [audioSourcePlayer play];
    }
}
bool MyboDevice::isOtherAudioPlaying(){
    return false;
}
void MyboDevice::proloadMilleuBgMusic(const std::string musicName){
    _stoppedMilleuBgMusic = false;
    std::string fullPath = FileUtils::getInstance()->fullPathForFilename(musicName);
    if (fullPath.size()>0) {
        if (audioSourcePlayer) {
            [audioSourcePlayer release];
            audioSourcePlayer = nullptr;
        }
        NSError *error = nil;
        audioSourcePlayer = [(AVAudioPlayer*)[AVAudioPlayer alloc] initWithContentsOfURL
                             :[NSURL fileURLWithPath:[NSString stringWithUTF8String
                                                      :fullPath.c_str()]] error:&error];
        audioSourcePlayer.volume = 1;
        audioSourcePlayer.numberOfLoops = -1;
    }else{
        NSLog(@"not play music file");
    }
}

void MyboDevice::stopMilleuBgMusic(){
    if (audioSourcePlayer) {
        _stoppedMilleuBgMusic = true;
        _pauseMilleuBgMusic = false;
        [audioSourcePlayer stop];
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

void MyboDevice::resumeMilleuBgMusic(){
    if (audioSourcePlayer) {
        if (!_stoppedMilleuBgMusic) {
            _pauseMilleuBgMusic = false;
            _stoppedMilleuBgMusic = false;
            [audioSourcePlayer play];
        }else{
            NSLog(@"music stopped");
        }
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

void MyboDevice::puaseMilleuBgMusic(){
    if (audioSourcePlayer) {
        _pauseMilleuBgMusic = true;
        [audioSourcePlayer pause];
    }else{
        //        NSLog(@"audioSourcePlayer is null");
    }
}

