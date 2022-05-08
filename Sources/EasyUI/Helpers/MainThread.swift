//
//  MainThread.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

struct MainThread {
  static func run(_ block: @escaping (() -> Void)) {
    if Thread.isMainThread {
      block()
    } else {
      DispatchQueue.main.async {
        block()
      }
    }
  }
}
