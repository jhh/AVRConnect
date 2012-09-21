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

#define VOLUME_EVENT(type) _eventType = type; _floatValue = integer2float(fsm.i);

struct EventFSM {
    // Ragel variables
    int  cs, act;
    char *ts, *te;
    // state machine variables
    int i;
};

float integer2float(int i) {
  return i < 100 ? i : (i / 10.0);
}

%%{
    machine event_parser;
    access fsm.;

    action on      { _boolValue = 1; }
    action standby { _boolValue = 0; }
    action digit   { fsm.i = fsm.i * 10.0 + (fc - '0'); }

    cr    = '\r';
    digits = digit+ @digit . cr;

    pw    = 'PW'     . ('ON' @on | 'STANDBY' @standby ) . cr;
    mv    = 'MV'     . digits;
    mvmax = 'MVMAX ' . digits;
    cvfl  = 'CVFL '  . digits;
    cvfr  = 'CVFR '  . digits;
    cvc   = 'CVC '   . digits;
    cvsw  = 'CVSW '  . digits;
    cvsl  = 'CVSL '  . digits;
    cvsr  = 'CVSR '  . digits;
    cvsbl = 'CVSBL ' . digits;
    cvsbr = 'CVSBR ' . digits;
    cvsb  = 'CVSB '  . digits;

    main := |*
      pw    => { _eventType = AVRPowerEvent; };
      mv    => { VOLUME_EVENT(AVRMasterVolumeEvent) };
      mvmax => { VOLUME_EVENT(AVRMasterVolumeMaxEvent) };
      cvfl  => { VOLUME_EVENT(AVRChannelVolumeFrontLeftEvent) };
      cvfr  => { VOLUME_EVENT(AVRChannelVolumeFrontRightEvent) };
      cvc   => { VOLUME_EVENT(AVRChannelVolumeCenterEvent) };
      cvsw  => { VOLUME_EVENT(AVRChannelVolumeSubwooferEvent) };
      cvsl  => { VOLUME_EVENT(AVRChannelVolumeSurroundLeftEvent) };
      cvsr  => { VOLUME_EVENT(AVRChannelVolumeSurroundRightEvent) };
      cvsbl => { VOLUME_EVENT(AVRChannelVolumeSurroundBackLeftEvent) };
      cvsbr => { VOLUME_EVENT(AVRChannelVolumeSurroundBackRightEvent) };
      cvsb  => { VOLUME_EVENT(AVRChannelVolumeSurroundBackEvent) };

      alnum+ . cr => { _eventType = AVRUnknownEvent; };
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
        fsm.i = 0;
        char *p  = (char *)[rawEvent cStringUsingEncoding:NSASCIIStringEncoding];
        char *pe = p + strlen(p) + 1;
        %% write init;
        %% write exec;
    }
    return self;
}

@end
