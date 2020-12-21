//
//  SFSafariController.swift
//  flutter_torico_id_login
//
//  Created by 0maru on 2020/12/21.
//

import Foundation
import SafariServices

@available(iOS 9.0, *)
public class SFSafariController: SFSafariViewController, SFSafariViewControllerDelegate {
  public func open(_ url: String) {
    if let flutterViewController = UIApplication.shared.delegate?.window?.unsafelyUnwrapped.rootViewController as? FlutterViewController {
      let safari: SFSafariViewController
      let url = URL(string: url)
      if let url = url {
        safari = SFSafariViewController(url: url)
        flutterViewController.present(safari, animated: true) {
          return
        }
      }
    }
  }
}
