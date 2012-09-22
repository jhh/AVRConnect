//
//  AVRConnection.m
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

#import "AVRConnection.h"
#import "AVREvent.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define TELNET_PORT 23

// declare private methods

@interface AVRConnection ()
- (dispatch_fd_t) _fileDescriptorToHost:(NSString *)host onPort:(uint16_t)port;
- (void) _processData:(dispatch_data_t) data;
@end

@implementation AVRConnection

#pragma mark Initializers

- (id) initWithDelegate:(id<AVRDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _delegateQueue = delegateQueue;
        _socketQueue = dispatch_queue_create("AVRConnect", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark Connecting

- (BOOL) connectToHost:(NSString *)host error:(NSError **)error {
    return [self connectToHost:host onPort:TELNET_PORT error:error];
}

- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error {
    // TODO: error handling
    _carry = dispatch_data_empty;
    dispatch_fd_t fd = [self _fileDescriptorToHost:host onPort:port];
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, self.socketQueue, 0);
    dispatch_io_set_low_water(_channel, 5);

    dispatch_io_read(_channel, 0, SIZE_MAX, self.delegateQueue, ^(bool done, dispatch_data_t data, int error) {
        if(data) {
            [self _processData:data];
        }
        if(error) NSLog(@"READ ERROR!!!");
        if(done) NSLog(@"DONE!!!");
    });
    return TRUE;
}

#pragma mark Utility Methods

- (void) sendCommand:(NSString *)command {
    command = [command stringByAppendingString:@"\r"];
    const char *command_buf = [command cStringUsingEncoding:NSASCIIStringEncoding];
    dispatch_data_t message = dispatch_data_create(command_buf, strlen(command_buf), dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC);
    dispatch_after(delay, dispatch_get_global_queue(0, 0), ^{
        dispatch_io_write(_channel, 0, message, self.socketQueue, ^(bool done, dispatch_data_t data, int error) {
            if(error) NSLog(@"WRITE ERROR!!!");
        });
    });
}

- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval {
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_time_t now = dispatch_walltime(DISPATCH_TIME_NOW, 0);
    dispatch_source_set_timer(_timer, now, interval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{ [self sendCommand:command]; });
    dispatch_resume(_timer);
}

#pragma mark Private Methods

- (dispatch_fd_t) _fileDescriptorToHost:(NSString *)host onPort:(uint16_t)port {

    struct sockaddr_in sock_addr;

    int sock = socket(PF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        NSLog(@"Socket error: %s (%d)", strerror(errno), errno);
    }

    bzero(&sock_addr, sizeof(sock_addr));
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    inet_pton(AF_INET, [host cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr);

    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof(sock_addr)) == -1) {
        NSLog(@"Connect error to %@: %s (%d)", host, strerror(errno), errno);
    }

    return sock;
}

- (void) _processData:(dispatch_data_t)data {

    const void *buffer;
    size_t size;

    // create a single buffer to parse
    dispatch_data_t mapped = dispatch_data_create_map(dispatch_data_create_concat(_carry, data), &buffer, &size);
    assert(mapped != NULL);

    // start will point to beginning of a response, end will point to end (\r)
    const void *start = buffer, *end;

    // parse responses by \r delimiter
    while ((end = memchr(start, 0x0d, (buffer+size) - start)) != NULL) {
        // add 1 to length to include \r for parser
        NSString *response = [[NSString alloc] initWithBytes:start length:end-start+1 encoding:NSASCIIStringEncoding];
        [self.delegate connection:self didReceiveEvent:[[AVREvent alloc] initWithString:response]];
        start = end + 1;
    }

    // check for partial response left in buffer and carry over for concatination with next
    if ((buffer+size) - start > 0) {
        _carry = dispatch_data_create(start, (buffer+size) - start, dispatch_get_global_queue(0,0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    } else {
        _carry = dispatch_data_empty;
    }
}

@end
