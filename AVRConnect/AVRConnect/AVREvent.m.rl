//
//  AVREvent.m
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

#import "AVREvent.h"

#define BUFLEN 136

struct EventFSM {
    // Ragel variables
    int  cs, act;
    char *ts, *te;
    // state machine variables
    char buffer[BUFLEN+1];
    int i;
};

%%{
    machine event_parser;
    access fsm.;

    action on      { _boolValue = 1; }
    action standby { _boolValue = 0; }
    action digit   { fsm.i = fsm.i * 10.0 + (fc - '0'); }

    action power {
        _eventType = AVRPowerEvent;
    }
    
    action mv {
        _eventType = AVRMasterVolumeEvent;
        _floatValue = fsm.i < 100 ? fsm.i : (fsm.i / 10.0);
    }

    action unknown {
        _eventType = AVRUnknownEvent;
        
    }

    cr = '\r';
    power = 'PW' . ('ON' @on | 'STANDBY' @standby ) . cr;
    mv = ('MV' @mv) . digit+ @digit . cr;

    main := |*
    power => power;
    mv => mv;
    alnum+ . cr => unknown;
    *|;

    write data;

}%%

@interface AVREvent ()
@property(readwrite) BOOL boolValue;
@property(readwrite) NSString *stringValue;
@end

@implementation AVREvent

- (id) initWithString:(NSString *) rawEvent {
    self = [super init];
    if (self) {
        _rawEvent = [rawEvent substringToIndex:([rawEvent length] - 1)];
        struct EventFSM fsm;
        char *p  = (char *)[rawEvent cStringUsingEncoding:NSASCIIStringEncoding];
        char *pe = p + strlen(p) + 1;
        %% write init;
        %% write exec;
    }
    return self;
}

@end
