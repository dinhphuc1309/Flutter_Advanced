import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let TOAST_CHANNEL = "com.example.research_method_channel/toast"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let flutterViewController = window?.rootViewController as! FlutterViewController
        
        FlutterMethodChannel(name: TOAST_CHANNEL, binaryMessenger: flutterViewController.binaryMessenger).setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self = self else { return }
            
            switch call.method {
            case "showToast":
                let arguments = call.arguments;
                self.showToast(message:arguments as! String)
                result("IOS")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController?.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}

