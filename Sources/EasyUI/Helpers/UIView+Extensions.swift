//
//  File.swift
//  
//
//  Created by Suykorng on 5/2/23.
//

import UIKit

extension UIView {
  final func squircle(_ cornerRadius: CGFloat = 10) {
    if #available(iOS 13.0, *) {
      layer.cornerCurve = .continuous
    }
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
  }
}
