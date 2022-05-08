//
//  UIScrollViewController.swift
//  
//
//  Created by Phanith on 29/1/22.
//

import UIKit

open class UIScrollViewController: UIViewController {
  
  public var keyboardWillShowHandler: ((CGFloat) -> Swift.Void)?
  public var keyboardWillHideHandler: (() -> Swift.Void)?
  
  // MARK: - Properties
  
  public var backgroundColor: UIColor? = .white {
    didSet {
      scrollView.backgroundColor = backgroundColor
      contentView.backgroundColor = backgroundColor
      view.backgroundColor = backgroundColor
    }
  }
  
  public private(set) lazy var scrollView = ScrollView().build {
    $0.backgroundColor = .white
    $0.alwaysBounceVertical = true
    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    $0.keyboardDismissMode = .interactive
  }
  
  public private(set) lazy var contentView = UIView().build {
    $0.backgroundColor = .white
  }
  
  // MARK: - ViewController's lifecycle
  
  open override func loadView() {
    super.loadView()
    
    configureViews()
    configureKeyboardObservers()
  }
  
  deinit {
    removeKeyboardObservers()
  }
  
  // MARK: - Configure Views
  
  private func configureViews() {
    scrollView.layout {
      view.addSubview($0)
      $0.top()
        .bottom()
      
      if #available(iOS 11.0, *) {
        $0.leading(constraint: view.safeAreaLayoutGuide.leadingAnchor)
          .trailing(constraint: view.safeAreaLayoutGuide.trailingAnchor)
      } else {
        $0.leading(constraint: view.leadingAnchor)
          .trailing(constraint: view.trailingAnchor)
      }
    }
    
    contentView.layout {
      scrollView.addSubview($0)
      $0.top()
        .left()
        .width(dimension: scrollView.widthAnchor)
        .bottom()
    }
  }
  
  // MARK: - Private
  
  private func configureKeyboardObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc
  private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {return}
    guard var keyboardFrame: CGRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
    let aFrame = keyboardFrame
    keyboardFrame = scrollView.convert(aFrame, from: nil)
    let intersect: CGRect = keyboardFrame.intersection(scrollView.bounds)
    if !intersect.isNull {
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
      guard let curveKey = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {return}
      let curve: Int = curveKey << 16
      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curve)), animations: {
        self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: intersect.size.height, right: 0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: intersect.size.height, right: 0)
      }, completion: { [weak self] _ in
        self?.keyboardWillShowHandler?(intersect.size.height)
      })
    }
  }
  
  @objc
  private func keyboardWillHide(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {return}
    guard let duraton = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
    guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {return}
    UIView.animate(withDuration: duraton, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curve)), animations: {
      self.scrollView.contentInset = .zero
      self.scrollView.scrollIndicatorInsets = .zero
    }, completion: { [weak self] _ in
      self?.keyboardWillHideHandler?()
    })
  }
}
