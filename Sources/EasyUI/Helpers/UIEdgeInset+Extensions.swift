//
//  UIEdgeInset+Extensions.swift
//  
//
//  Created by Phanith on 22/3/23.
//

import UIKit

extension UIEdgeInsets {
  public static func inset(_ inset: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }
  
  public static func dx(_ inset: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }
  
  public static func dy(_ inset: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
  }
}
