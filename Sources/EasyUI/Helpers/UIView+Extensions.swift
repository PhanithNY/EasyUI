//
//  UIView+Extensions.swift
//  
//
//  Created by Suykorng on 5/2/23.
//

import UIKit

extension UIView {
//  public final func squircle(_ cornerRadius: CGFloat = 10, masksToBounds: Bool = true) {
//    if #available(iOS 13.0, *) {
//      layer.cornerCurve = .continuous
//    }
//    layer.cornerRadius = cornerRadius
//    layer.masksToBounds = masksToBounds
//  }
  
  public final func renderBorder(_ borderWidth: CGFloat = 0.66,
                                 borderColor: UIColor = .defaultBorderColor) {
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderWidth
  }
}
