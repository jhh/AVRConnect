//
//  AVREvent.h
//  AVRConnect
//
//  Created by Jeff Hutchison on 9/19/2012.
//  Copyright (c) 2012 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    AVRUnknownEvent,
    AVRPowerEvent,                           // PW
    AVRMasterVolumeEvent,                    // MV
    AVRMuteEvent,                            // MU
    AVRInputSourceEvent,                     // SI
    AVRInputSourceNameEvent,                 // SSFUN
    AVRInputSourceUsageEvent,                // SSSOD
    AVRMainZoneEvent,                        // ZM
    AVRRecordSelectEvent,                    // SR
    AVRInputModeEvent,                       // SD
    AVRDigitalInputModeEvent,                // DC
    AVRVideoSelectModeEvent,                 // SV
    AVRSurroundModeEvent,                    // MS
    AVRHDMISettingEvent,                     // VS
    AVRAudioParameterEvent,                  // PS
    AVRPictureAdjustEvent,                   // PV
    AVRZone2Event,                           // Z2
    AVRZone3Event,                           // Z3
    AVRZone4Event,                           // Z4
    AVRAnalogRadioFrequencyEvent,            // TFAN
    AVRXMRadioFrequencyEvent,                // TFXM
    AVRHDRadioFrequencyEvent,                // TFHD******
    AVRHDRadioMulticastChannelEvent,         // TFHDM*
    AVRDABRadioFrequencyEvent,               // TFDAB
    AVRAnalogRadioPresetEvent,               // TPAN
    AVRXMRadioPresetEvent,                   // TPXM
    AVRHDRadioPresetEvent,                   // TPHD
    AVRDABRadioPresetEvent,                  // TPDAB
    AVRAnalogRadioBandOrModeEvent,           // TMAN
    AVRHDRadioBandOrModeEvent,               // TMHD
    AVRDABRadioBandOrModeEvent,              // TMDAB
    AVRRadioHDStatusEvent,                   // HD
    AVRRadioDABStatusEvent,                  // DA
    AVRRadioXMStatusEvent,                   // XM
    AVRNetUSBDisplayASCIIEvent,              // NSA
    AVRNetUSBDisplayUTF8Event,               // NSE
    AVRNSREvent,                             // NSR
    AVRNSHEvent,                             // NSH
    AVRiPodDisplayASCIIEvent,                // IPA
    AVRiPodDisplayUTF8Event,                 // IPE
    AVRLockEvent,                            // SY
    AVRSpeakerStatusEvent,                   // SSSPC
    AVRRMEvent,                              // RM
    AVRMasterVolumeMaxEvent,                 // MVM
    AVRChannelVolumeFrontLeftEvent,          // CVFL
    AVRChannelVolumeFrontRightEvent,         // CVFR
    AVRChannelVolumeCenterEvent,             // CVC
    AVRChannelVolumeSubwooferEvent,          // CVSW
    AVRChannelVolumeSurroundLeftEvent,       // CVSL
    AVRChannelVolumeSurroundRightEvent,      // CVSR
    AVRChannelVolumeSurroundBackLeftEvent,   // CVSBL
    AVRChannelVolumeSurroundBackRightEvent,  // CVSBR
    AVRChannelVolumeSurroundBackEvent,       // CVSB
};
typedef NSUInteger AVREventType;

@interface AVREvent : NSObject

@property(readonly) NSString *rawEvent;
@property(readonly) NSString *property;
@property(readonly) AVREventType eventType;
@property(readonly) BOOL boolValue;
@property(readonly) float floatValue;
@property(readonly) NSString *stringValue;
@property(readonly) NSInteger integerValue;

- (id) initWithString:(NSString *)rawEvent;

@end
