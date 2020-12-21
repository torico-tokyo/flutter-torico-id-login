import Flutter
import UIKit
import SafariServices
import AuthenticationServices

public class SwiftFlutterToricoIdLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding, {
  var session: Any? = nil
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_torico_id_login",
      binaryMessenger: registrar.messenger()
    )
    let instance = SwiftFlutterToricoIdLoginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "authentication":
      authentication(call, result: result)
      break
    default:
      result(FlutterMethodNotImplemented)
      break
    }
  }
  
  public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! NSDictionary
    let url = args["url"] as! String
    let urlScheme = args["redirectURL"] as! String
    
    if #available(iOS 12.0, *) {
      // ASWebAuthenticationSession
      var authSession: ASWebAuthenticationSession?
      authSession = ASWebAuthenticationSession(
        url: URL(string: url)!,
        callbackURLScheme: urlScheme
      ) { url, error in
        result(url?.absoluteString)
        authSession!.cancel()
        self.session = nil
      }
      self.session = authSession
      if #available(iOS 13.0, *) {
        authSession?.presentationContextProvider = self
      }
      if !authSession!.start() {
        
      }
    } else if #available(iOS 11.0, *) {
      // SFAuthenticationSession
      var authSession: SFAuthenticationSession?
      authSession = SFAuthenticationSession(
        url: URL(string: url)!,
        callbackURLScheme: urlScheme
      ) { url, error in
        result(url?.absoluteString)
        authSession!.cancel()
        self.session = nil
      }
      self.session = authSession
      if !authSession!.start() {
        
      }
    } else if #available(iOS 9.0, *){
      // SFSafariViewController
      // Safari のCookieが使えない
      let url = URL(string: url)
      SFSafariController.open(url)
    } else {
      // iOS 9.0以前は未対応
      result(nil)
      return
    }
  }
  
  @available(iOS 12.0, *)
  public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
      return UIApplication.shared.delegate!.window!!
  }
}
