//
//  UnitTests.m
//  AVRConnecdt
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import "UnitTests.h"
#import <AVRConnect/AVRConnect.h>

@implementation UnitTests

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testUnknownEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"FOOBAR\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRUnknownEvent, @"eventType is wrong");
}

- (void)testPowerEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"PWON\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRPowerEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"PWON", @"rawEvent is wrong");
    STAssertTrue(event.boolValue, @"parameter value is wrong");

    event = [[AVREvent alloc] initWithString:@"PWSTANDBY\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRPowerEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"PWSTANDBY", @"rawEvent is wrong");
    STAssertFalse(event.boolValue, @"parameter value is wrong");
}

- (void)testMasterVolumeEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"MV39\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMasterVolumeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MV39", @"rawEvent is wrong");
    STAssertEquals(event.floatValue, (float)39.0, @"parameter value is wrong");

    event = [[AVREvent alloc] initWithString:@"MV245\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMasterVolumeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MV245", @"rawEvent is wrong");
    STAssertEquals(event.floatValue, (float)24.5, @"parameter value is wrong");
}

- (void)testMasterVolumeMaxEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"MVMAX 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMasterVolumeMaxEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MVMAX 80", @"rawEvent is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");

    event = [[AVREvent alloc] initWithString:@"MVMAX 245\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMasterVolumeMaxEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MVMAX 245", @"rawEvent is wrong");
    STAssertEquals(event.floatValue, (float)24.5, @"parameter value is wrong");
}

- (void)testChannelVolumeFrontLeftEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVFL 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeFrontLeftEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");

    event = [[AVREvent alloc] initWithString:@"CVFL 245\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeFrontLeftEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)24.5, @"parameter value is wrong");
}

- (void)testChannelVolumeFrontRightEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVFR 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeFrontRightEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeCenterEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVC 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeCenterEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSubwooferEvent{
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSW 110\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSubwooferEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)11.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSurroundLeftEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSL 81\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSurroundLeftEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)81.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSurroundRightEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSR 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSurroundRightEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSurroundBackLeftEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSBL 215\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSurroundBackLeftEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)21.5, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSurroundBackRightEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSBR 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSurroundBackRightEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");
}

- (void)testAVRChannelVolumeSurroundBackEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"CVSB 80\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRChannelVolumeSurroundBackEvent, @"eventType is wrong");
    STAssertEquals(event.floatValue, (float)80.0, @"parameter value is wrong");
}

- (void)testAVRMuteEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"MUON\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMuteEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MUON", @"rawEvent is wrong");
    STAssertTrue(event.boolValue, @"parameter value is wrong");

    event = [[AVREvent alloc] initWithString:@"MUOFF\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMuteEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"MUOFF", @"rawEvent is wrong");
    STAssertFalse(event.boolValue, @"parameter value is wrong");
}

- (void) testAVRInputSourceEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"SIPHONO\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRInputSourceEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"PHONO", @"stringValue parameter is wrong");

    event = [[AVREvent alloc] initWithString:@"SITV/CBL\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRInputSourceEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"TV/CBL", @"stringValue parameter is wrong");
}

- (void)testAVRMainZoneEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"ZMON\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRMainZoneEvent, @"eventType is wrong");
    STAssertTrue(event.boolValue, @"parameter value is wrong");
}

- (void) testAVRRecordSelectEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"SRNET/USB\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRRecordSelectEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"NET/USB", @"stringValue parameter is wrong");
}

- (void) testAVRInputModeEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"SDEXT.IN-1\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRInputModeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"EXT.IN-1", @"stringValue parameter is wrong");
}

- (void) testAVRDigitalInputModeEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"DCPCM\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRDigitalInputModeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"PCM", @"stringValue parameter is wrong");
}

- (void) testAVRVideoSelectModeEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"SVSOURCE\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRVideoSelectModeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"SOURCE", @"stringValue parameter is wrong");
}

- (void) testAVRSurroundModeEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"MSM CH IN+PL2X M\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRSurroundModeEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"M CH IN+PL2X M", @"stringValue parameter is wrong");
}

- (void) testAVRHDMISettingEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"VSSC72P\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRHDMISettingEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"SC72P", @"stringValue parameter is wrong");
}

- (void) testAVRAudioParameterEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"PSRSTR MODE1\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRAudioParameterEvent, @"eventType is wrong");
    STAssertEqualObjects(event.stringValue, @"RSTR MODE1", @"stringValue parameter is wrong");

    event = [[AVREvent alloc] initWithString:@"PSBAS 03\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRAudioParameterEvent, @"eventType is wrong");
    STAssertEqualObjects(event.rawEvent, @"PSBAS 03", @"rawEvent is wrong");
    STAssertEquals(event.integerValue, (NSInteger)3, @"integerValue parameter is wrong");
    STAssertEqualObjects(event.stringValue, @"BAS", @"stringValue parameter is wrong");

    event = [[AVREvent alloc] initWithString:@"PSLFE 10\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRAudioParameterEvent, @"eventType is wrong");
    STAssertEquals(event.integerValue, (NSInteger)10, @"integerValue parameter is wrong");
    STAssertEqualObjects(event.stringValue, @"LFE", @"stringValue parameter is wrong");

    event = [[AVREvent alloc] initWithString:@"PSDEL 123\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRAudioParameterEvent, @"eventType is wrong");
    STAssertEquals(event.integerValue, (NSInteger)123, @"integerValue parameter is wrong");
    STAssertEqualObjects(event.stringValue, @"DEL", @"stringValue parameter is wrong");
}

- (void) testAVRPictureAdjustEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"PVCN 06\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRPictureAdjustEvent, @"eventType is wrong");
    STAssertEquals(event.integerValue, (NSInteger)6, @"integerValue parameter is wrong");
    STAssertEqualObjects(event.stringValue, @"CN", @"stringValue parameter is wrong");

    event = [[AVREvent alloc] initWithString:@"PVHUE 17\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRPictureAdjustEvent, @"eventType is wrong");
    STAssertEquals(event.integerValue, (NSInteger)17, @"integerValue parameter is wrong");
    STAssertEqualObjects(event.stringValue, @"HU", @"stringValue parameter is wrong");
}

@end
