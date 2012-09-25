//
//  main.m
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

