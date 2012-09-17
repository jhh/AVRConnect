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

    _connection = [[AVRConnection alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    [_connection connectToHost:@"10.0.1.2" error:&error];

    _font = [NSFont fontWithName:@"Consolas" size:12.0];
    _attrsDictionary = [NSDictionary dictionaryWithObject:_font forKey:NSFontAttributeName];

}

- (void) connection:(AVRConnection *)connection didReceiveEvent:(NSString *)event {
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [NSDate date], event];
    NSAttributedString* as = [[NSAttributedString alloc] initWithString:message attributes:_attrsDictionary];
    NSTextStorage* text = self.textView.textStorage;
    [text beginEditing];
    [text appendAttributedString: as];
    [text endEditing];
    NSRange r = NSMakeRange(text.length, 0);
    [self.textView scrollRangeToVisible: r];
}

@end
