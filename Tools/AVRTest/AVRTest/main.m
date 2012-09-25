//
//  main.m
//  AVRTest
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVRTest.h"

static AVRTest *tester;

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        tester = [[AVRTest alloc] init];
        if (argc == 2) {
            tester.host = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        }
        [tester start];
        dispatch_main();
    }
    return 0;
}

