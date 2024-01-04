import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    GMSServices.provideAPIKey("AIzaSyBm8d4V9W5dKj7MUe2lryhfZjc9u6Vp_Vs")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
