//
//  Config.swift
//  
//
//  Created by PhanithNY on 1/10/20.
//

import UIKit

public protocol Config { }
extension NSObject: Config { }

extension Config where Self: NSObject {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().build {
  ///       $0.textAlignment = .center
  ///       $0.textColor = .black
  ///       $0.text = "Hi There!"
  ///     }
  public func build(_ closure: (Self) -> Void) -> Self {
    closure(self)
    return self
  }
}
