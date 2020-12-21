#import "FlutterToricoIdLoginPlugin.h"
#if __has_include(<flutter_torico_id_login/flutter_torico_id_login-Swift.h>)
#import <flutter_torico_id_login/flutter_torico_id_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_torico_id_login-Swift.h"
#endif

@implementation FlutterToricoIdLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterToricoIdLoginPlugin registerWithRegistrar:registrar];
}
@end
