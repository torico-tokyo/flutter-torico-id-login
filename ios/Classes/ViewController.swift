//
//  ViewController.swift
//  flutter_torico_id_login
//
//  Created by 0maru on 2020/12/21.
//

import Foundation

class ViewController {
  static func get() -> UIViewController {
    let viewController = UIApplication.shared.windows.filter { (v) -> Bool in
        v.isHidden == false
    }.first?.rootViewController
    return viewController!
  }
}
