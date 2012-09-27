//
//  APPDelegate.h
//  AVRConsole
//
//  Created by Jeff Hutchison on 9/16/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    connection = [[AVRConnection alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    // TODO: hangs on refused connection
    [connection connectToHost:@"10.0.1.2" error:&error];
    [connection sendCommand:@"PW?" withInterval:30];

    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    eventAttrs = @{ NSFontAttributeName : font };
    unknownEventAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [NSColor grayColor] };
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}

- (void) connection:(AVRConnection *)connection didReceiveEvent:(AVREvent *)event {
    NSDictionary *attrsDictionary = event.eventType == AVRUnknownEvent ? unknownEventAttrs : eventAttrs;
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [dateFormatter stringFromDate:[NSDate date]], [event rawEvent]];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:attrsDictionary];
    NSTextStorage *text = self.textView.textStorage;
    [text beginEditing];
    [text appendAttributedString:as];
    [text endEditing];
    [self.textView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}

- (IBAction)queryInputSources:(id)sender {
    [connection sendCommand:@"SSFUN ?"];
}

- (IBAction)queryInputSourceUsage:(id)sender {
    [connection sendCommand:@"SSSOD ?"];
}

- (IBAction)querySpeakerStatus:(id)sender {
    [connection sendCommand:@"SSSPC ?"];
}

- (IBAction)querySpeakerChannelStatus:(id)sender {
    [connection sendCommand:@"PSCHN ?"];
}

- (IBAction)sendCommand:(NSTextField *)sender {
    [connection sendCommand:[sender stringValue]];
}

- (IBAction)saveDocument:(NSMenuItem *)sender {
    NSString *name = @"AVR Console Output.txt";

    // Set the default name for the file and show the panel.
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:name];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theFile = [panel URL];
            NSLog(@"FILE: %@", theFile);
            NSTextStorage *text = self.textView.textStorage;
            NSError *error;
            [[text mutableString] writeToURL:theFile atomically:YES encoding:NSASCIIStringEncoding error:&error];
        }
    }];

}

@end
