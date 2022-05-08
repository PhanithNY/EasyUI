//
//  ScrollView.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

public final class ScrollView: UIScrollView {
  public override func touchesShouldCancel(in view: UIView) -> Bool {
    if type(of: view) == UITextField.self || type(of: view) == UITextView.self {
      return true
    }
    return super.touchesShouldCancel(in: view)
  }
}
