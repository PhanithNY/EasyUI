//
//  UIWingTextField.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

open class EasyUITextField: UITextField {
  
  public enum InputType {
    case currency
    case `default`
    case email
    case number
    case phone
  }
  
  // MARK: - Properties
  
  public var onFocus: ((UITextField) -> Swift.Void)?
  public var onLossFocus: ((UITextField) -> Swift.Void)?
  public var onRightViewTap: ((UITextField) -> Swift.Void)?
  
  /// If allowEditing is false, this closure will invoke when user tap.
  public var onTap: ((UITextField) -> Void)?
  
  /// Whether editable or not. Default is `true`.
  public var allowEditing: Bool = true
  
  /// Rect for left view.
  public var leftViewRect: CGRect?
  
  /// Rect for right view.
  public var rightViewRect: CGRect?
  
  /// Padding for text.
  public var padding: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
  
  private var maximumAllowedCharacters: Int?
  private var preferredInputType: InputType = .default
  
  private let leftImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var rightImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRightView(_:)))
    imageView.addGestureRecognizer(tapGesture)
    return imageView
  }()
  
  // MARK: - Init / Deinit
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    prepareLayouts()
  }

  required public init?(coder: NSCoder) {
    fatalError()
  }
  
  public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
  
  public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.rightViewRect(forBounds: bounds)
    if let rect = self.rightViewRect {
      return CGRect(x: bounds.width - rect.width - rect.minX, y: rect.minY, width: rect.width, height: rect.height)
    }
    textRect.origin.x -= padding.right
    return textRect
  }
  
  public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    return leftViewRect ?? CGRect(x: 2, y: 2, width: 32, height: 32)
  }
  
  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}

// MARK: - Actions

public extension EasyUITextField {
  final func setMaximumAllowedCharacters(_ count: Int?) {
    maximumAllowedCharacters = count
  }
  
  final func setPreferredInputType(_ inputType: InputType) {
    preferredInputType = inputType
    switch inputType {
    case .currency:
      keyboardType = .decimalPad
      
    case .default:
      keyboardType = .default
      
    case .email:
      keyboardType = .emailAddress
      
    case .number:
      keyboardType = .numberPad
      
    case .phone:
      keyboardType = .phonePad
    }
  }
  
  final func setLeftViewImage(_ image: UIImage?, tintColor: UIColor?) {
    if let tintColor = tintColor {
      leftImageView.tintColor = tintColor
    }
    leftImageView.image = image
    
    leftView = leftImageView
    leftViewMode = .always
  }
  
  final func setLeftView(_ view: UIView, tappable: Bool = true) {
    if tappable {
      addTapGesture(for: view)
    }
    leftView = view
    leftViewMode = .always
  }
  
  final func setRightViewImage(_ image: UIImage?, tintColor: UIColor?) {
    if let tintColor = tintColor {
      rightImageView.tintColor = tintColor
    }
    rightImageView.image = image
    
    rightView = rightImageView
    rightViewMode = .always
  }
  
  final func setRightView(_ view: UIView, tappable: Bool = true) {
    if tappable {
      addTapGesture(for: view)
    }
    rightView = view
    rightViewMode = .always
  }
  
  @objc
  private func didTapRightView(_ sender: UITapGestureRecognizer) {
    onRightViewTap?(self)
  }
  
  private func addTapGesture(for view: UIView) {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRightView(_:)))
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapGesture)
  }
}

// MARK: - Layouts

extension EasyUITextField {
  private func prepareLayouts() {
    showKeyboardDismissButton()
    borderStyle = .roundedRect
    delegate = self
  }
}

// MARK: - UITextFieldDelegate

extension EasyUITextField: UITextFieldDelegate {
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if !allowEditing {
      onTap?(textField)
      return false
    }
    
    return true
  }
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    onFocus?(textField)
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    onLossFocus?(textField)
  }
  
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch preferredInputType {
    case .currency:
      // In case currency input, lock right decimal to 2 digit at max.
      return textField.text.orEmpty.replaceCommaWithDot(using: string, in: range)
      
    default:
      // In case have numberOfCharacters, lock max character to numberOfCharacters.
      if let maximumAllowedCharacters = maximumAllowedCharacters {
        let text = textField.text.orEmpty
        let newLength = text.count + string.count - range.length
        return newLength <= maximumAllowedCharacters
      }
      return true
    }
  }
}
