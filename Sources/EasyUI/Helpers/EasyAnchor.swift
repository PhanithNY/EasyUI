import UIKit

extension UIView {
  
  enum ConstantType {
    case lessThanOrEqual
    case equal
    case greaterThanOrEqual
  }
  
  var useAutoLayout: Bool {
    get {
      !translatesAutoresizingMaskIntoConstraints
    }
    set {
      translatesAutoresizingMaskIntoConstraints = !newValue
    }
  }
  
  /// Layout view using wrapper closure.
  /// - Parameter closure: The configuration closure of current view
  final func layout(using closure: ((UIView) -> Void)) {
    translatesAutoresizingMaskIntoConstraints = false
    closure(self)
  }
  
  /// Remove all subviews from current view
  final func removeSubviews() {
    subviews.forEach { $0.removeFromSuperview() }
  }
  
  @discardableResult
  @available(*, deprecated, renamed: "width")
  final func setWidth(_ constant: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  @discardableResult
  @available(*, deprecated, renamed: "width")
  final func setWidth(dimension: NSLayoutDimension, multiplier: CGFloat = 1) -> Self {
    widthAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
    return self
  }
  
  @discardableResult
  @available(*, deprecated, renamed: "height")
  final func setHeight(_ constant: CGFloat) -> Self {
    heightAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  @discardableResult
  @available(*, deprecated, renamed: "height")
  final func setHeight(dimension: NSLayoutDimension, multiplier: CGFloat = 1) -> Self {
    heightAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
    return self
  }
  
  /// Apply width constraint with multiplier.
  /// - Parameters:
  ///   - dimension: The NSLayoutDimension that compared to.
  ///   - multiplier: The multiplier value compared to dimension. Default is 1.0
  /// - Returns: current view
  @discardableResult
  final func width(dimension: NSLayoutDimension, multiplier: CGFloat = 1.0) -> Self {
    widthAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
    return self
  }
  
  /// Apply width constaint.
  /// - Parameter constant: The constant value for anchor.
  /// - Returns: current view
  @discardableResult
  final func width(_ constant: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  /// Apply width constraint.
  /// - Parameters:
  ///   - constantType: The constant type for this constraint. Default to .equal
  ///   - constant: The constant value for constraint.
  /// - Returns: current view
  @discardableResult
  final func width(_ constantType: ConstantType = .equal, _ constant: CGFloat) -> Self {
    switch constantType {
    case .lessThanOrEqual:
      widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    case .equal:
      widthAnchor.constraint(equalToConstant: constant).isActive = true
    case .greaterThanOrEqual:
      widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
    return self
  }
  
  /// Apply height constraint with multiplier.
  /// - Parameters:
  ///   - dimension: The NSLayoutDimension that compared to.
  ///   - multiplier: The multiplier value compared to dimension. Default is 1.0
  /// - Returns: current view
  @discardableResult
  final func height(dimension: NSLayoutDimension, multiplier: CGFloat = 1.0) -> Self {
    heightAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
    return self
  }
  
  /// Apply height constaint.
  /// - Parameter constant: The constant value for anchor.
  /// - Returns: current view
  @discardableResult
  final func height(_ constant: CGFloat) -> Self {
    heightAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  /// Apply height constraint.
  /// - Parameters:
  ///   - constantType: The constant type for this constraint. Default to .equal
  ///   - constant: The constant value for constraint.
  /// - Returns: current view
  @discardableResult
  final func height(_ constantType: ConstantType = .equal, _ constant: CGFloat) -> Self {
    switch constantType {
    case .lessThanOrEqual:
      heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    case .equal:
      heightAnchor.constraint(equalToConstant: constant).isActive = true
    case .greaterThanOrEqual:
      heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
    return self
  }
  
  /// Apply width and height constraint to the provided constant.
  /// - Parameter size: The target constant value.
  /// - Returns: current view
  @discardableResult
  final func size(equalTo size: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: size).isActive = true
    heightAnchor.constraint(equalToConstant: size).isActive = true
    return self
  }
  
  /// Apply width and height constraint.
  /// - Parameters:
  ///   - width: The constant value for width.
  ///   - height: The constant value for height.
  /// - Returns: current view
  @discardableResult
  final func size(width: CGFloat, height: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: width).isActive = true
    heightAnchor.constraint(equalToConstant: height).isActive = true
    return self
  }
  
  /// Apply top constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview topAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func top(constraint: NSLayoutYAxisAnchor? = nil, _ constant: CGFloat = 0.0) -> Self {
    topAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.topAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    return self
  }
  
  /// Apply left constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview leftAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func left(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0.0) -> Self {
    leftAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.leftAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    return self
  }
  
  /// Apply leading constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview leadingAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func leading(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    leadingAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.leadingAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    return self
  }
  
  /// Apply bottom constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview bottomAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func bottom(constraint: NSLayoutYAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    bottomAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.bottomAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    return self
  }
  
  /// Apply right constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview rightAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func right(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    rightAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.rightAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    return self
  }
  
  /// Apply trailing constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview trailingAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func trailing(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    trailingAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.trailingAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    return self
  }
  
  /// Fill this view to its superview
  /// - Parameter insets: The insets from superview
  /// - Returns: current view
  @discardableResult
  final func fill(insets: UIEdgeInsets = .zero) -> Self {
    topAnchor.constraint(equalTo: superview.unsafelyUnwrapped.topAnchor, constant: insets.top).isActive = true
    leftAnchor.constraint(equalTo: superview.unsafelyUnwrapped.leftAnchor, constant: insets.left).isActive = true
    bottomAnchor.constraint(equalTo: superview.unsafelyUnwrapped.bottomAnchor, constant: -insets.bottom).isActive = true
    rightAnchor.constraint(equalTo: superview.unsafelyUnwrapped.rightAnchor, constant: -insets.right).isActive = true
    return self
  }
  
  /// Apply centerX constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview centerXAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func centerX(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    centerXAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.centerXAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    return self
  }
  
  /// Apply centerY constraint.
  /// - Parameters:
  ///   - constraint: The target anchor that compared to. Default to superview centerYAnchor.
  ///   - constant: The constant value for constraint
  /// - Returns: current view
  @discardableResult
  final func centerY(constraint: NSLayoutYAxisAnchor? = nil, _ constant: CGFloat = 0) -> Self {
    centerYAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.centerYAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    return self
  }
  
  /// Center this view inside the provided view.
  /// - Parameter view: The target view. Default is superview.
  /// - Returns: current view
  @discardableResult
  final func center(in view: UIView? = nil) -> Self {
    centerXAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.centerXAnchor : view.unsafelyUnwrapped.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.centerYAnchor : view.unsafelyUnwrapped.centerYAnchor).isActive = true
    return self
  }
  
  /// Apply top and left constraint.
  /// - Parameters:
  ///   - view: The target view. Default to superview.
  ///   - top: The top constant.
  ///   - left: The left constant.
  /// - Returns: current view
  @discardableResult
  final func topLeft(_ view: UIView? = nil, top: CGFloat = 0, left: CGFloat = 0) -> Self {
    topAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.topAnchor : view.unsafelyUnwrapped.topAnchor, constant: top).isActive = true
    leftAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.leftAnchor : view.unsafelyUnwrapped.leftAnchor, constant: left).isActive = true
    return self
  }
  
  /// Apply bottom and left constraint.
  /// - Parameters:
  ///   - view: The target view. Default to superview.
  ///   - bottom: The bottom constant.
  ///   - left: The left constant.
  /// - Returns: current view
  @discardableResult
  final func bottomLeft(_ view: UIView? = nil, bottom: CGFloat = 0, left: CGFloat = 0) -> Self {
    bottomAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.bottomAnchor : view.unsafelyUnwrapped.bottomAnchor, constant: -bottom).isActive = true
    leftAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.leftAnchor : view.unsafelyUnwrapped.leftAnchor, constant: left).isActive = true
    return self
  }
  
  /// Apply top and right constraint.
  /// - Parameters:
  ///   - view: The target view. Default to superview.
  ///   - top: The top constant.
  ///   - right: The right constant.
  /// - Returns: current view
  @discardableResult
  final func topRight(_ view: UIView? = nil, top: CGFloat = 0, right: CGFloat = 0) -> Self {
    topAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.topAnchor : view.unsafelyUnwrapped.topAnchor, constant: top).isActive = true
    rightAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.rightAnchor : view.unsafelyUnwrapped.rightAnchor, constant: -right).isActive = true
    return self
  }
  
  /// Apply bottom and right constraint.
  /// - Parameters:
  ///   - view: The target view. Default to superview.
  ///   - bottom: The bottom constant.
  ///   - right: The right constant.
  /// - Returns: current view
  @discardableResult
  final func bottomRight(_ view: UIView? = nil, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
    bottomAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.bottomAnchor : view.unsafelyUnwrapped.bottomAnchor, constant: -bottom).isActive = true
    rightAnchor.constraint(equalTo: view == nil ? superview.unsafelyUnwrapped.rightAnchor : view.unsafelyUnwrapped.rightAnchor, constant: -right).isActive = true
    return self
  }
  
  @discardableResult
  final func top(constraint: NSLayoutYAxisAnchor? = nil, _ constant: CGFloat = 0.0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      topAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.topAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .equal:
      topAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.topAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .greaterThanOrEqual:
      topAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.topAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    }
    return self
  }
  
  @discardableResult
  final func left(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0.0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      leftAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.leftAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .equal:
      leftAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.leftAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .greaterThanOrEqual:
      leftAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.leftAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    }
    return self
  }
  
  @discardableResult
  final func bottom(constraint: NSLayoutYAxisAnchor? = nil, _ constant: CGFloat = 0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      bottomAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.bottomAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .equal:
      bottomAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.bottomAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .greaterThanOrEqual:
      bottomAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.bottomAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    }
    return self
  }
  
  @discardableResult
  final func right(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      rightAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.rightAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .equal:
      rightAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.rightAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .greaterThanOrEqual:
      rightAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.rightAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    }
    return self
  }
  
  @discardableResult
  final func leading(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      leadingAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.leadingAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .equal:
      leadingAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.leadingAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    case .greaterThanOrEqual:
      leadingAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.leadingAnchor : constraint.unsafelyUnwrapped, constant: constant).isActive = true
    }
    return self
  }
  
  @discardableResult
  final func trailing(constraint: NSLayoutXAxisAnchor? = nil, _ constant: CGFloat = 0, priority: ConstantType = .equal) -> Self {
    switch priority {
    case .lessThanOrEqual:
      trailingAnchor.constraint(lessThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.trailingAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .equal:
      trailingAnchor.constraint(equalTo: constraint == nil ? superview.unsafelyUnwrapped.trailingAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    case .greaterThanOrEqual:
      trailingAnchor.constraint(greaterThanOrEqualTo: constraint == nil ? superview.unsafelyUnwrapped.trailingAnchor : constraint.unsafelyUnwrapped, constant: -constant).isActive = true
    }
    return self
  }
}
