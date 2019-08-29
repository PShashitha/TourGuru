//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <augmented_reality_plugin_wikitude/WikitudePlugin.h>
#import <flutter_tts/FlutterTtsPlugin.h>
#import <google_maps_flutter/GoogleMapsPlugin.h>
#import <location/LocationPlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [WikitudePlugin registerWithRegistrar:[registry registrarForPlugin:@"WikitudePlugin"]];
  [FlutterTtsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTtsPlugin"]];
  [FLTGoogleMapsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleMapsPlugin"]];
  [LocationPlugin registerWithRegistrar:[registry registrarForPlugin:@"LocationPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
