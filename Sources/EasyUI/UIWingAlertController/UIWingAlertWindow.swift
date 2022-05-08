//
//  UIWingAlertWindow.swift
//  
//
//  Created by Phanith on 8/3/22.
//

import UIKit

final class UIWingAlertWindow: UIWindow {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
    backgroundColor = UIColor.black.withAlphaComponent(0.25)
    windowLevel = .alert + 1
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
