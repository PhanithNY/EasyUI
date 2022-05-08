//
//  UIDialogueViewController.swift
//  
//
//  Created by Phanith on 29/1/22.
//

import UIKit

open class UIDialogueViewController: UIViewController {
  
  // MARK: - Properties
  
  open var allowKeyboardObservation: Bool {
    true
  }
  
  open var allowDismissOnTap: Bool {
    false
  }
  
  open var horizontalPadding: CGFloat {
    50
  }
  
  open var prefersSlideInTransition: Bool {
    true
  }
  
  open var prefersVisualEffect: Bool {
    true
  }
  
  open var transitionDuration: TimeInterval {
    0.3
  }
  
  public var onDeinit: (() -> Swift.Void)?
  
  public var effectViewBackgroundColor: UIColor? {
    didSet {
      if let effectViewBackgroundColor = effectViewBackgroundColor {
        effectView.backgroundColor = effectViewBackgroundColor
      }
    }
  }
  
  public let contentView = UIView().build {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10.0
    $0.layer.masksToBounds = true
    if #available(iOS 13.0, *) {
      $0.layer.cornerCurve = .continuous
    }
  }
  
  private lazy var effectView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: .dark)
    let effectView = UIVisualEffectView(effect: blur)
    return effectView
  }()
  
  // MARK: - Init / Deinit
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }
  
  required public init?(coder: NSCoder) {
    fatalError()
  }
  
  deinit {
    if allowKeyboardObservation {
      removeKeyboardObservers()
    }
    onDeinit?()
  }
  
  // MARK: - ViewController's lifecycle
  
  public override var prefersHomeIndicatorAutoHidden: Bool { true }
  
  open override func loadView() {
    super.loadView()
    
    prepareLayouts()
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    if allowKeyboardObservation {
       addKeyboardObservers()
    }
    
    if prefersSlideInTransition {
      contentView.setNeedsLayout()
      contentView.layoutIfNeeded()
      
      let transform: CGAffineTransform = .init(translationX: 0, y: contentView.bounds.height)
      contentView.transform = transform
      contentView.alpha = 0.0
    }
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: transitionDuration, delay: 0.0, options: [.curveEaseInOut]) { [self] in
      contentView.transform = .identity
      contentView.alpha = 1.0
    } completion: { _ in }
  }
  
  // MARK: - Actions
  
  @objc
  public final func dismissWithSlideOut(_ completion: (() -> Void)? = nil) {
    let transform: CGAffineTransform = .init(translationX: 0, y: contentView.bounds.height)
    UIView.animate(withDuration: transitionDuration, delay: 0.0, options: [.curveEaseInOut]) { [self] in
      contentView.transform = transform
      effectView.alpha = 0.25
      contentView.alpha = 0.0
      view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
    } completion: { [self] _ in
      dismiss(animated: true, completion: completion)
    }
  }
  
  @objc
  private func didTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: view)
    if contentView.frame.contains(location) {
      return
    }
    
    switch prefersSlideInTransition {
    case true:
      dismissWithSlideOut(nil)
      
    case false:
      dismiss(animated: true, completion: nil)
    }
  }
  
  // MARK: - Prepare layouts
  
  private func prepareLayouts() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    if prefersVisualEffect {
      effectView.layout {
        view.addSubview($0)
        $0.fill()
      }
      view.backgroundColor = .clear
    }
    
    contentView.layout {
      view.addSubview($0)
      if UIDevice.current.userInterfaceIdiom == .pad {
        $0.width(375 - 32)
          .center()
      } else {
        if #available(iOS 11.0, *) {
          $0.left(constraint: view.safeAreaLayoutGuide.leftAnchor, horizontalPadding)
            .right(constraint: view.safeAreaLayoutGuide.rightAnchor, horizontalPadding)
            .centerY()
        } else {
          $0.left(constraint: view.leftAnchor, horizontalPadding)
            .right(constraint: view.rightAnchor, horizontalPadding)
            .centerY()
        }
      }
    }
    
    if allowDismissOnTap {
      let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTap(_:)))
      view.addGestureRecognizer(tapGesture)
    }
  }
}

// MARK: - KVO

extension UIDialogueViewController {
  private func addKeyboardObservers() {
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
    keyboardFrame = contentView.convert(aFrame, from: nil)
    let intersect: CGRect = keyboardFrame.intersection(contentView.bounds)
    if !intersect.isNull {
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
      guard let curveKey = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {return}
      let curve: Int = curveKey << 16
      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curve)), animations: {
        self.contentView.transform = .init(translationX: 0, y: -(intersect.size.height + self.horizontalPadding))
      }, completion: nil)
    }
  }

  @objc
  private func keyboardWillHide(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {return}
    guard let duraton = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
    guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {return}
    UIView.animate(withDuration: duraton, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curve)), animations: {
      self.contentView.transform = .identity
    }, completion: nil)
  }
}
