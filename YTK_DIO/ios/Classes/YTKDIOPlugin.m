#import "YTKDIOPlugin.h"
#if __has_include(<YTK_DIO/YTK_DIO-Swift.h>)
#import <YTK_DIO/YTK_DIO-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "YTK_DIO-Swift.h"
#endif

@implementation YTKDIOPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYTKDIOPlugin registerWithRegistrar:registrar];
}
@end
