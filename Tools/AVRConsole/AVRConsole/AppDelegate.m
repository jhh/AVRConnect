//
//  AVRConsole.m
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

@end
