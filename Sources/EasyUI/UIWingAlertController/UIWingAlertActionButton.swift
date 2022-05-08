//
//  UIWingAlertActionButton.swift
//  
//
//  Created by Phanith on 8/3/22.
//

import UIKit

final class UIWingAlertActionButton: UIButton {
  
  // MARK: - Properties
  
  public var font: UIFont? = UIFont.systemFont(ofSize: 15, weight: .medium) {
    didSet {
      titleLabel?.font = font
    }
  }
  
  public var title: String? {
    didSet {
      setTitleColor(style.foregroundColor, for: .normal)
      setTitle(title, for: .normal)
      titleLabel?.font = font
    }
  }
  
  public var style: UIWingAlertAction.Style = .default {
    didSet {
      backgroundColor = style.backgroundColor
      setTitleColor(style.foregroundColor, for: .normal)
      setTitle(title, for: .normal)
      titleLabel?.font = font
    }
  }
  
  // MARK: - Init
  
  private let handler: (() -> Void)?
  
  init(style: UIWingAlertAction.Style, handler: (() -> Void)?) {
    self.style = style
    self.handler = handler
    super.init(frame: .zero)
    
    prepareLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = bounds.height / 2.0
  }
  
  // MARK: - Actions
  
  @objc
  private func didTap(_ sender: UIWingAlertActionButton) {
    handler?()
  }
  
  // MARK: - Prepare layouts
  
  private func prepareLayouts() {
    backgroundColor = style.backgroundColor
    addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    
    let heightAnchor = heightAnchor.constraint(equalToConstant: 40)
    heightAnchor.priority = .defaultHigh
    heightAnchor.isActive = true
  }
}
