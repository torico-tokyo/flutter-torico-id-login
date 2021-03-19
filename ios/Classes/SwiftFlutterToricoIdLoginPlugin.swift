import Flutter
import UIKit
import SafariServices
import Foundation
import AuthenticationServices

public class SwiftFlutterToricoIdLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding {
  var session: Any? = nil
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "torico/flutter_torico_id_login",
      binaryMessenger: registrar.messenger()
    )
    let instance = SwiftFlutterToricoIdLoginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "authentication":
      authentication(call, result: result)
    case "logout":
      logout(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
      break
    }
  }
  
  public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! NSDictionary
    let url = args["url"] as! String
    let urlScheme = args["redirectURI"] as! String
    let forceLogin = args["forceLogin"] as! Bool
    
    if (forceLogin) {
      let url = URL(string: url)
      if let url = url {
        let safari = SFSafariController.init(url: url)
        safari.open(url: url)
        return
      }
    }
    
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
      // Safari のCookieが使えないのでログイン情報の共有は出来ない
      let url = URL(string: url)
      if let url = url {
        let safari = SFSafariController.init(url: url)
        safari.open(url: url)
        return
      }
    } else {
      // iOS 9.0以前は未対応
      result(nil)
      return
    }
  }
  
  public func logout(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! NSDictionary
    let url = args["url"] as! String
    let urlScheme = args["redirectURI"] as! String

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
      // Safari のCookieが使えないのでログイン情報の共有は出来ない
      let url = URL(string: url)
      if let url = url {
        let safari = SFSafariController.init(url: url)
        safari.open(url: url)
        return
      }
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

