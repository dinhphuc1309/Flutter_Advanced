import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let DEFAULT_METHOD_CHANNEL = "com.example.flutter_advanced/defaultMethodChannel"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let flutterViewController = window?.rootViewController as! FlutterViewController
        
        FlutterMethodChannel(name: DEFAULT_METHOD_CHANNEL, binaryMessenger: flutterViewController.binaryMessenger).setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            
            switch call.method {
            case "getStringDeviceInfo":
                if let arguments = call.arguments as? Dictionary<String, Any>,
                   let type = arguments["type"] as? String, !type.isEmpty {
                    result(self.getDeviceInfoString(type: type))
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Arguments must contain a non-null String for key 'type'",
                        details: nil
                    ))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func getDeviceInfoString(type: String) -> String? {
        if type == "MODEL" {
            return UIDevice.current.model
        }
        return nil
    }
}

