//
//  AVRTest.h
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

#import "AVRTest.h"
#import <AVRConnect/AVRConnect.h>

@implementation AVRTest

- (id) init {
    self = [super init];
    if (self) {
        self.host = @"10.0.1.2";
    }
    return self;
}

- (void) start {
    _connection = [[AVRConnection alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    [_connection connectToHost:self.host error:nil];
    [_connection sendPowerQuery];
}

- (void) connection:(AVRConnection *)connection didReceiveEvent:(NSString *)event {
    NSLog(@"event: %@", event);
}
@end
