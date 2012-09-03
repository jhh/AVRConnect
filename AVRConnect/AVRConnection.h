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

@protocol AVRDelegate <NSObject>

- (void) connection:(AVRConnection *)connection didReceiveEvent:(NSString *)event;

@end

@interface AVRConnection : NSObject {
    @private
    dispatch_data_t _carry;
    dispatch_io_t _channel;
}

@property (weak)             id<AVRDelegate> delegate;
@property (copy, readonly)   NSString *host;
@property (assign, readonly) NSUInteger port;

- (id) initWithDelegate:(id<AVRDelegate>)delegate host:(NSString *)host;
- (id) initWithDelegate:(id<AVRDelegate>)delegate host:(NSString *)host port:(NSUInteger)port;
- (void) sendPowerQuery;

@end
