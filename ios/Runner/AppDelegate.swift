import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let DEFAULT_METHOD_CHANNEL = "com.example.flutter_advanced/defaultMethodChannel"
    
    private let EVENT_CHANNEL = "com.example.flutter_advanced/eventChannel"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let flutterViewController = window?.rootViewController as! FlutterViewController
        
        //Default method channel
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
        
        //Event channel
        let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: flutterViewController.binaryMessenger)
        eventChannel.setStreamHandler(CountDownStreamHandler())
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func getDeviceInfoString(type: String) -> String? {
        if type == "MODEL" {
            return UIDevice.current.model
        }
        return nil
    }
}

class CountDownStreamHandler: NSObject, FlutterStreamHandler {
    private var timer: Timer?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard var seconds = arguments as? Int else {
            return FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument type", details: nil)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            events(seconds)
            seconds -= 1
            
            if seconds < 0 {
                timer.invalidate()
                events(FlutterEndOfEventStream)
            }
        }
        return nil
        
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timer?.invalidate()
        return nil
    }
}

