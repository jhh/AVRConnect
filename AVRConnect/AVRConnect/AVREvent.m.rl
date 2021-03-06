//
//  AVREvent.m.rl
//  AVRConnect
//
//  Created by Jeff Hutchison on 9/19/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import "AVREvent.h"

#define VOLUME_EVENT(type) _eventType = type; _floatValue = integer2float(fsm.i)
#define SELECT_EVENT(type) _eventType = type; \
    _stringValue = [_rawEvent substringWithRange:NSMakeRange(2, [_rawEvent length]-2)]

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

    # use ivars instead of properties because these run in init
    action on    { _boolValue = 1; }
    action off   { _boolValue = 0; }
    action digit { fsm.i = fsm.i * 10.0 + (fc - '0'); }

    cr    = '\r';
    digits = digit+ @digit . cr;

    pw    = 'PW'     . ('ON' @on | 'STANDBY' @off ) . cr;
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
    mu    = 'MU'     . ('ON' @on | 'OFF' @off ) . cr;
    si    = 'SI'     . ascii+ . cr;
    zm    = 'ZM'     . ('ON' @on | 'OFF' @off ) . cr;
    sr    = 'SR'     . ascii+ . cr;
    sd    = 'SD'     . ascii+ . cr;
    dc    = 'DC'     . ascii+ . cr;
    sv    = 'SV'     . ascii+ . cr;
    ms    = 'MS'     . ascii+ . cr;
    vs    = 'VS'     . ascii+ . cr;
    # TODO: PS event incomplete
    ps    = 'PS'     . ascii+ . cr;
    psint = 'PS'     . ('BAS' | 'TRE' | 'LFE' | 'DEL' | 'DIM' | 'CEN' | 'CEI') . ' ' . digits;
    # HUE returned as HU
    pv    = 'PV'     . ('CN' | 'BR' | 'CM' | 'HUE' ) . ' ' . digits;

    main := |*
      pw    => { _eventType = AVRPowerEvent; };
      mv    => { VOLUME_EVENT(AVRMasterVolumeEvent); };
      mvmax => { VOLUME_EVENT(AVRMasterVolumeMaxEvent); };
      cvfl  => { VOLUME_EVENT(AVRChannelVolumeFrontLeftEvent); };
      cvfr  => { VOLUME_EVENT(AVRChannelVolumeFrontRightEvent); };
      cvc   => { VOLUME_EVENT(AVRChannelVolumeCenterEvent); };
      cvsw  => { VOLUME_EVENT(AVRChannelVolumeSubwooferEvent); };
      cvsl  => { VOLUME_EVENT(AVRChannelVolumeSurroundLeftEvent); };
      cvsr  => { VOLUME_EVENT(AVRChannelVolumeSurroundRightEvent); };
      cvsbl => { VOLUME_EVENT(AVRChannelVolumeSurroundBackLeftEvent); };
      cvsbr => { VOLUME_EVENT(AVRChannelVolumeSurroundBackRightEvent); };
      cvsb  => { VOLUME_EVENT(AVRChannelVolumeSurroundBackEvent); };
      mu    => { _eventType = AVRMuteEvent; };
      si    => { SELECT_EVENT(AVRInputSourceEvent); };
      zm    => { _eventType = AVRMainZoneEvent; };
      sr    => { SELECT_EVENT(AVRRecordSelectEvent); };
      sd    => { SELECT_EVENT(AVRInputModeEvent); };
      dc    => { SELECT_EVENT(AVRDigitalInputModeEvent); };
      sv    => { SELECT_EVENT(AVRVideoSelectModeEvent); };
      ms    => { SELECT_EVENT(AVRSurroundModeEvent); };
      vs    => { SELECT_EVENT(AVRHDMISettingEvent); };
      psint => {
          _eventType    = AVRAudioParameterEvent;
          _integerValue = fsm.i;
          _stringValue  = [_rawEvent substringWithRange:NSMakeRange(2, 3)];
      };
      ps    => { SELECT_EVENT(AVRAudioParameterEvent); };
      pv => {
          _eventType    = AVRPictureAdjustEvent;
          _integerValue = fsm.i;
          _stringValue  = [_rawEvent substringWithRange:NSMakeRange(2, 2)];
      };

      alnum+ . cr => { _eventType = AVRUnknownEvent; };
    *|;

    write data;

}%%

@interface AVREvent ()
@property(readwrite) BOOL boolValue;
@property(readwrite) float floatValue;
@property(readwrite) NSString *stringValue;
@property(readwrite) NSInteger integerValue;
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
        char *eof = pe;
        %% write init;
        %% write exec;
    }
    return self;
}

@end
