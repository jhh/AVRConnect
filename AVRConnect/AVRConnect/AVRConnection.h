//
//  AVRConnection.h
//  AVRConnect
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

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
