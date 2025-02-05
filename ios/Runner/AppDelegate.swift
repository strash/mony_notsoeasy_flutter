import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let reviewChannel = FlutterMethodChannel(
            name: "strash.mony/review",
            binaryMessenger: controller.binaryMessenger)
        
        reviewChannel.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            if call.method == "requestReview" {
                if #available(iOS 13.0, *), let scene = controller.view.window?.windowScene {
                    ReviewService.requestReview(from: scene, result: result)
                    result(nil)
                } else {
                    result(FlutterError(
                        code: "NO_WINDOW_SCENE",
                        message: "No window scene available",
                        details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

@objc class ReviewService: NSObject {
    @objc static func requestReview(from scene: Any, result: FlutterResult) -> Void {
        if #available(iOS 16.0, *), let window = scene as? UIWindowScene {
            Task {
                await AppStore.requestReview(in: window)
            }
        } else if #available(iOS 13.0, *){
            SKStoreReviewController.requestReview()
        }
        result(String("Review was requested"))
    }
}

