//
//  UIWingAlertController.swift
//  
//
//  Created by Phanith on 8/3/22.
//

import UIKit

public final class UIWingAlertController: UIViewController {
  
  static let window: UIWingAlertWindow = .init(frame: UIScreen.main.bounds)
  
  // MARK: - Properties
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10.0
    if #available(iOS 13.0, *) {
      view.layer.cornerCurve = .continuous
    }
    view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
    view.layer.shadowRadius = 15
    view.layer.shadowOffset = .init(width: 0, height: 0)
    view.layer.shadowOpacity = 1.0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [])
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private var stackViewLeadingConstraint: NSLayoutConstraint?
  private var stackViewTrailingConstraint: NSLayoutConstraint?
  private var stackViewCenterXConstraint: NSLayoutConstraint?
  
  // MARK: - Init / Deinit
  
  private let _title: String?
  private let _message: String
  
  public init(title: String?, message: String) {
    self._title = title
    self._message = message
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
    modalPresentationCapturesStatusBarAppearance = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  deinit {
    print(type(of: self), "deinit.")
  }
  
  // MARK: - Lifecycle
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  public override func loadView() {
    super.loadView()
    
    prepareLayouts()
    renderUIContents()
    applyStackViewLayouts()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let transform: CGAffineTransform = .init(scaleX: 1.25, y: 1.25)
    contentView.transform = transform
    contentView.alpha = 0.0
    UIWingAlertController.window.alpha = 0.0
    
    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut) { [self] in
      contentView.alpha = 1.0
      contentView.transform = .identity
      UIWingAlertController.window.alpha = 1.0
    } completion: { _ in }
  }
  
  // MARK: - Actions
  
  public final func makeVisible() {
    UIWingAlertController.window.rootViewController = self
    UIWingAlertController.window.makeKeyAndVisible()
  }
  
  public final func addAction(_ action: UIWingAlertAction) {
    let actionButton: UIWingAlertActionButton = .init(style: action.style) { [unowned self] in
      execute(action)
    }
    
    actionButton.title = action.title
    stackView.addArrangedSubview(actionButton)
    
    let isVertical: Bool = stackView.arrangedSubviews.count > 2
    stackView.axis = isVertical ? .vertical : .horizontal
  }
  
  private func execute(_ action: UIWingAlertAction) {
    if #available(iOS 13.0, *){
      dismiss(animated: true) { [weak self] in
        self?.view.window?.isHidden = true
        self?.view.window?.rootViewController = nil
        action.handler?(action)
      }
    } else {
      view.window?.isHidden = true
      view.window?.rootViewController = nil
      dismiss(animated: false)
      action.handler?(action)
    }
  }
  
  private func renderUIContents() {
    let attributedText: NSMutableAttributedString
    if let _title = _title, !_title.isEmpty {
      attributedText = NSMutableAttributedString(string: _title, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.darkText])
      attributedText.append(NSAttributedString(string: "\n\n\n", attributes: [.font: UIFont.systemFont(ofSize: 5)]))
      attributedText.append(NSAttributedString(string: _message, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular), .foregroundColor: UIColor.darkGray]))
    } else {
      attributedText = NSMutableAttributedString(string: _message, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium), .foregroundColor: UIColor.darkGray])
    }
    titleLabel.attributedText = attributedText
  }
  
  private func applyStackViewLayouts() {
    let numberOfArrangedSubviews: Int = stackView.arrangedSubviews.count
    let isCenterX: Bool = numberOfArrangedSubviews == 1
    switch isCenterX {
    case true:
      stackViewCenterXConstraint?.isActive = true
      stackViewLeadingConstraint?.isActive = false
      stackViewTrailingConstraint?.isActive = false
      if let actionButton = stackView.arrangedSubviews.first as? UIWingAlertActionButton {
        actionButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
      }
      
    case false:
      stackViewCenterXConstraint?.isActive = false
      stackViewLeadingConstraint?.isActive = true
      stackViewTrailingConstraint?.isActive = true
    }
  }
  
  // MARK: - Layouts
  
  private func prepareLayouts() {
    view.addSubview(contentView)
    let maxWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 28*2
    let availableWidth: CGFloat = min(320, maxWidth)
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalToConstant: availableWidth),
      contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    contentView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
      contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 32)
    ])
    
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
    ])
    
    stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
    stackViewLeadingConstraint?.priority = .defaultHigh
    
    stackViewTrailingConstraint = contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 24)
    stackViewTrailingConstraint?.priority = .defaultHigh
    
    stackViewCenterXConstraint = stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    stackViewCenterXConstraint?.priority = .defaultHigh
  }
}
