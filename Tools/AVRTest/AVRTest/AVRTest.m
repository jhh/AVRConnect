//
//  AVRTest.m
//  AVRTest
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import "AVRTest.h"

@implementation AVRTest

- (id) init {
    self = [super init];
    if (self) {
        self.host = @"10.0.1.2";
    }
    return self;
}

- (void) start {
    connection = [[AVRConnection alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    [connection connectToHost:self.host error:nil];
    [connection sendCommand:@"PW?" withInterval:30];
}

- (void) connection:(AVRConnection *)connection didReceiveEvent:(AVREvent *)event {
    NSLog(@"event: %@", event.rawEvent);
}
@end
