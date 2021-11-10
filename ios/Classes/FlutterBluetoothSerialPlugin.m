#import <AVFoundation/AVFoundation.h>
//#import <ExternalAccessory/ExternalAccessory.h>
#import "FlutterBluetoothSerialPlugin.h"

@implementation FlutterBluetoothSerialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  NSLog(@"called registerWithRegistrar");
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_bluetooth_serial/methods"
            binaryMessenger:[registrar messenger]];
  FlutterBluetoothSerialPlugin* instance = [[FlutterBluetoothSerialPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSLog(@"FlutterBluetoothSerialPlugin: called %@", call.method);
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"getBondedDevices" isEqualToString:call.method]) {

    // NSLog(@"FlutterBluetoothSerialPlugin: getBondedDevices called");
    // NSArray *connectedAccessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]; 
    // NSLog(@"FlutterBluetoothSerialPlugin: Total number of connected devices is %d", [connectedAccessories count]);
    // for (EAAccessory* connectedAccessory in connectedAccessories) {
    //   NSLog(@"FlutterBluetoothSerialPlugin: name: %@ ", connectedAccessory.name);
    //   NSLog(@"FlutterBluetoothSerialPlugin: isConnected: %@ ", connectedAccessory.isConnected ? @"Yes" : @"No");
    // }

    NSMutableArray<NSMutableDictionary *> * list = [NSMutableArray new];

    NSArray<AVAudioSessionPortDescription *> * outputs = [[[AVAudioSession sharedInstance] currentRoute] outputs ];
    NSLog(@"FlutterBluetoothSerialPlugin: session.currentRoute.outputs count %d", [outputs count]);
    for (AVAudioSessionPortDescription *portDesc in outputs) {
      NSMutableDictionary *entry = [NSMutableDictionary dictionary];
      entry[@"address"] = portDesc.UID;
      entry[@"name"] = portDesc.portName;
      entry[@"type"] = @1;
      entry[@"isConnected"] = @YES;
      entry[@"bondState"] = @12;
      [list addObject:entry];
      NSLog(@"FlutterBluetoothSerialPlugin: portDesc UID %@", portDesc.UID);
      NSLog(@"FlutterBluetoothSerialPlugin: portDesc portName %@", portDesc.portName);
      NSLog(@"FlutterBluetoothSerialPlugin: portDesc portType %@", portDesc.portType);
      NSLog(@"FlutterBluetoothSerialPlugin: portDesc channels %@", portDesc.channels);
    }

    result(list);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
