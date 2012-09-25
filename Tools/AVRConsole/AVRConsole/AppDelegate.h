//
//  APPDelegate.h
//  AVRConsole
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVRConnect/AVRConnect.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, AVRDelegate> {
    @private
    AVRConnection *connection;
    NSDictionary *eventAttrs, *unknownEventAttrs;
    NSDateFormatter *dateFormatter;
}

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

- (IBAction)queryInputSources:(id)sender;
- (IBAction)queryInputSourceUsage:(id)sender;
- (IBAction)querySpeakerStatus:(id)sender;
- (IBAction)querySpeakerChannelStatus:(id)sender;
- (IBAction)sendCommand:(NSTextField *)sender;

@end
