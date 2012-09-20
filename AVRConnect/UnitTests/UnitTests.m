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

- (void)testUnknownEvent {
    AVREvent *event = [[AVREvent alloc] initWithString:@"FOOBAR\r"];
    STAssertEquals(event.eventType, (AVREventType)AVRUnknownEvent, @"eventType is wrong");
}


@end
