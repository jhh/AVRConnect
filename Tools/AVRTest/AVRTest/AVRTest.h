//
//  AVRTest.h
//  AVRTest
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVRConnect.h"


@interface AVRTest : NSObject <AVRDelegate> {
    @private
    AVRConnection *connection;
}

@property NSString *host;

- (id) init;
- (void) start;
@end
