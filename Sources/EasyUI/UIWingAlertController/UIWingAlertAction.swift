//
//  UIWingAlertAction.swift
//  
//
//  Created by Phanith on 8/3/22.
//

import UIKit

public final class UIWingAlertAction {
  public enum Style {
    case `default`
    case cancel
    case destructive
    
    public var backgroundColor: UIColor {
      switch self {
      case .default:
        return UIColor(hex: "0077FF")
        
      case .cancel:
        return UIColor(hex: "E5E7EB")
        
      case .destructive:
        return UIColor(hex: "D8232A")
      }
    }
    
    public var foregroundColor: UIColor {
      switch self {
      case .default:
        return .white
        
      case .cancel:
        return UIColor(hex: "515C6F")
        
      case .destructive:
        return .white
      }
    }
  }
  
  private(set) var title: String
  private(set) var style: Style
  private(set) var handler: ((UIWingAlertAction) -> Void)?
  
  public init(title: String, style: Style, handler: ((UIWingAlertAction) -> Void)? = nil) {
    self.title = title
    self.style = style
    self.handler = handler
  }
}
