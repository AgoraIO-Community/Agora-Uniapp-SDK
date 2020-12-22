//
//  AgoraRtcEngineModule.m
//  AgoraRtcUniPlugin
//
//  Created by LXH on 2020/12/14.
//

#import "AgoraRtcEngineModule.h"

#if __has_include(<AgoraRtcUniPlugin/AgoraRtcUniPlugin-Swift.h>)
#import <AgoraRtcUniPlugin/AgoraRtcUniPlugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "AgoraRtcUniPlugin-Swift.h"
#endif

@implementation AgoraRtcEngineModule

@synthesize weexInstance = _weexInstance;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initManager];
    }
    return self;
}

- (void)setWeexInstance:(WXSDKInstance *)weexInstance {
    _weexInstance = weexInstance;
}

WX_EXPORT_METHOD(@selector(callMethod::))

@end
