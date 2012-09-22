//
//  AVRConnection.h
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

#import <Foundation/Foundation.h>
@class AVRConnection;
@class AVREvent;

@protocol AVRDelegate <NSObject>

- (void) connection:(AVRConnection *)connection didReceiveEvent:(AVREvent *)event;

@end

@interface AVRConnection : NSObject {
    @private
    dispatch_data_t _carry;
    dispatch_io_t _channel;
    dispatch_source_t _timer;
}

@property (weak) id<AVRDelegate> delegate;
@property dispatch_queue_t delegateQueue;
@property dispatch_queue_t socketQueue;

- (id) initWithDelegate:(id<AVRDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (BOOL) connectToHost:(NSString *)host error:(NSError **)error;
- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error;

// sends command after 200ms delay
- (void) sendCommand:(NSString *)command;

// interval in seconds, calling multiple time currently cancels previous timer
- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval;

@end
