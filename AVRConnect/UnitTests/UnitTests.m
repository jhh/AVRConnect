//
//  UnitTests.m
//
// Copyright 2012 Jeffrey Hutchison
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

@end
