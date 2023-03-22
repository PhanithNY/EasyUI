//
//  UITextField+Extensions.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

extension UITextField {
  public final func showKeyboardDismissButton(_ image: UIImage? = nil) {
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton: UIBarButtonItem
    if let image = image {
      doneButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(resignFirstResponder))
    } else {
      if #available(iOS 13.0, *) {
        doneButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(resignFirstResponder))
      } else {
        doneButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(resignFirstResponder))
      }
    }
    
    if #available(iOS 13.0, *) {
      doneButton.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
    } else {
      doneButton.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var toolBarItems = [UIBarButtonItem]()
    toolBarItems.append(flexSpace)
    toolBarItems.append(doneButton)
    
    let doneToolbar = UIToolbar()
    doneToolbar.isTranslucent = false
    if #available(iOS 13.0, *) {
      doneToolbar.tintColor = .label
    } else {
      doneToolbar.tintColor = .black
    }
    doneToolbar.barTintColor = UIColor.init(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    doneToolbar.backgroundColor = UIColor.init(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    doneToolbar.items = toolBarItems
    doneToolbar.sizeToFit()
    
    inputAccessoryView = doneToolbar
  }
}
