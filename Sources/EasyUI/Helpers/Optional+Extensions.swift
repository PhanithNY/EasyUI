//
//  Optional+Extensions.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

public extension Optional where Wrapped == String {
  var orEmpty: String {
    switch self {
    case .some(let value):
      return value
      
    case .none:
      return ""
    }
  }
}

public extension Optional {
  func or(_ value: Wrapped) -> Wrapped {
    switch self {
    case .some(let some):
      return some
      
    case .none:
      return value
    }
  }
}

