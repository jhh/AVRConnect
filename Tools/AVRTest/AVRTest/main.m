//
//  main.m
//  AVRTest
//
//  Created by Jeff Hutchison on 7/19/12.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define AVR_ADDRESS "10.0.1.2"


dispatch_data_t carry = dispatch_data_empty;

dispatch_fd_t get_fd() {
    struct sockaddr_in sock_addr;
    
    int sock = socket(PF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        NSLog(@"ERROR: socket");
    }
    
    bzero(&sock_addr, sizeof(sock_addr));
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(23);
    inet_pton(AF_INET, AVR_ADDRESS, &sock_addr.sin_addr);
    
    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof(sock_addr)) == -1) {
        NSLog(@"ERROR: connect");
    }
    
    return sock;
}

dispatch_data_t copy_one_data(const char *data, size_t size) {
    return dispatch_data_create(data, size, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
}

void avr_response(NSString *response) {
    // dispatch logging on main queue just because
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"command: %@\n", response);
    });
}

void avr_event(dispatch_data_t data) {
    const void *buffer;
    size_t size;

    // create a single buffer to parse
    dispatch_data_t mapped = dispatch_data_create_map(dispatch_data_create_concat(carry, data), &buffer, &size);
    assert(mapped != NULL);

    // start will point to beginning of a response, end will point to end (\r)
    void *start = (void *)buffer, *end;

    // parse responses by \r delimiter
    while ((end = memchr(start, 0x0d, (buffer+size) - start)) != NULL) {
        NSString *response = [[NSString alloc] initWithBytes:start length:end-start encoding:NSASCIIStringEncoding];
        avr_response(response);
        start = end + 1;
    }

    // check for partial response left in buffer and carry over for concatination with next
    if ((buffer+size) - start > 0) {
        carry = copy_one_data(start, (buffer+size) - start);
    } else {
        carry = dispatch_data_empty;
    }
    dispatch_release(mapped);
}



int main(int argc, const char * argv[]) {

    @autoreleasepool {
        dispatch_fd_t fd = get_fd();
        
        dispatch_io_t chan = dispatch_io_create(DISPATCH_IO_STREAM, fd, dispatch_get_main_queue(), 0);
        dispatch_io_set_low_water(chan, 5);
        
        dispatch_io_read(chan, 0, SIZE_MAX, dispatch_get_global_queue(0, 0), ^(bool done, dispatch_data_t data, int error) {
            if(data) {
                avr_event(data);
                dispatch_release(data);
            }
            if(error) NSLog(@"READ ERROR!!!");
            if(done) NSLog(@"DONE!!!");
        });
        
        const char *command_buf = "PW?\r";
        dispatch_data_t command = dispatch_data_create(command_buf, strlen(command_buf), dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_time_t now = dispatch_walltime(DISPATCH_TIME_NOW, 0);
        dispatch_source_set_timer(timer, now, 30ull*NSEC_PER_SEC, 1ull*NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_io_write(chan, 0, command, dispatch_get_global_queue(0, 0), ^(bool done, dispatch_data_t data, int error) {
                if(error) NSLog(@"WRITE ERROR!!!");
            });
        });        
        dispatch_resume(timer);
    }
    dispatch_main();
    return 0;
}

