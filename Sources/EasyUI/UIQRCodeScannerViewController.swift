//
//  QRCodeScannerViewController.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import AVFoundation
import UIKit

open class UIQRCodeScannerViewController: UIViewController {
  
  public var onResult: ((String) -> Swift.Void)?
  
  public enum DismissalMode {
    case dismiss
    case pop
  }
  
  // MARK: - Properties
  
  open var dismissalMode: DismissalMode {
    .pop
  }
  
  open var rectOfInterest: CGRect {
    rectView.frame
  }
  
  open var rectViewHorizontalPadding: CGFloat {
    50.0
  }
  
  open var errorTitle: String {
    "Scanning not supported"
  }
  
  open var errorMessage: String {
    "It seems like your device does not support scanning. Please make sure your device's camera is working."
  }
  
  open var errorButton: String {
    "OK"
  }
  
  open var scanFrameCornerColor: UIColor {
    .blue
  }
  
  public lazy var rectView: QRCornerRectangleView = {
    let view = QRCornerRectangleView()
    view.backgroundColor = .clear
    view.color = scanFrameCornerColor
    view.thickness = 5.0
    view.radius = 10.0
    view.length = 15
    return view
  }()
  
  private var captureSession: AVCaptureSession!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private let fillLayer = CAShapeLayer()
  private lazy var metadataOutput = AVCaptureMetadataOutput()
  
  // MARK: - Init / Deinit
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  open override var prefersStatusBarHidden: Bool { true }
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  
  open override func loadView() {
    super.loadView()
    
    prepareLayouts()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if let previewLayer = previewLayer {
      metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    if fillLayer.superlayer == nil {
      let bigRect = view.bounds
      let smallRect = rectView.frame
      let pathBigRect = UIBezierPath(rect: bigRect)
      let pathSmallRect = UIBezierPath(roundedRect: smallRect,
                                       byRoundingCorners: .allCorners,
                                       cornerRadii: CGSize(width: 12, height: 12))
      pathBigRect.append(pathSmallRect)
      pathBigRect.usesEvenOddFillRule = true

      fillLayer.path = pathBigRect.cgPath
      fillLayer.fillRule = .evenOdd
      fillLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
      view.layer.insertSublayer(fillLayer, below: rectView.layer)
    }
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    #if targetEnvironment(simulator)
    return
    #else
    startSession()
    #endif
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    stopSession()
  }
  
  // MARK: - Actions
  
  public final func startSession() {
    if captureSession?.isRunning == .some(false) {
      captureSession.startRunning()
    }
  }
  
  public final func stopSession() {
    if captureSession?.isRunning == .some(true) {
      captureSession.stopRunning()
    }
  }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension UIQRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()
    
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
        return
      }
      guard let stringValue = readableObject.stringValue else {
        return
      }
      dismissSelf {
        self.onResult?(stringValue)
      }
    } else {
      dismissSelf()
    }
  }
  
  private func dismissSelf(completion: (() -> Void)? = nil) {
    if completion != nil {
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(.success)
    }
    
    switch dismissalMode {
    case .dismiss:
      dismiss(animated: true, completion: completion)
      
    case .pop:
      CATransaction.begin()
      CATransaction.setCompletionBlock {
        completion?()
      }
      navigationController?.popViewController(animated: true)
      CATransaction.commit()
    }
    
  }
}

// MARK: - Layouts

extension UIQRCodeScannerViewController {
  private func prepareLayouts() {
    #if targetEnvironment(simulator)
    view.addSubview(rectView)
    rectView.translatesAutoresizingMaskIntoConstraints = false
    rectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: rectViewHorizontalPadding).isActive = true
    rectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rectViewHorizontalPadding).isActive = true
    rectView.heightAnchor.constraint(equalTo: rectView.widthAnchor, multiplier: 1.0).isActive = true
    rectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    #endif
    
    captureSession = AVCaptureSession()
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      return
    }
    
    let videoInput: AVCaptureDeviceInput
    
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed()
      return
    }
    
    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)
      
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128]
    } else {
      failed()
      return
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    
    view.addSubview(rectView)
    rectView.translatesAutoresizingMaskIntoConstraints = false
    rectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: rectViewHorizontalPadding).isActive = true
    rectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rectViewHorizontalPadding).isActive = true
    rectView.heightAnchor.constraint(equalTo: rectView.widthAnchor, multiplier: 1.0).isActive = true
    rectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    captureSession.startRunning()
  }
  
  private func failed() {
    let ac = UIAlertController(title: errorTitle,
                               message: errorMessage,
                               preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: errorButton, style: .default))
    present(ac, animated: true)
    captureSession = nil
    
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(.error)
  }
}

public final class QRCornerRectangleView: UIView {
  public var color = UIColor.black {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public var radius: CGFloat = 5 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public var thickness: CGFloat = 2 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public var length: CGFloat = 30 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  public override func draw(_ rect: CGRect) {
    color.set()
    
    let t2 = thickness / 2
    let path = UIBezierPath()
    // Top left
    path.move(to: CGPoint(x: t2, y: length + radius + t2))
    path.addLine(to: CGPoint(x: t2, y: radius + t2))
    path.addArc(withCenter: CGPoint(x: radius + t2, y: radius + t2), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
    path.addLine(to: CGPoint(x: length + radius + t2, y: t2))
    
    // Top right
    path.move(to: CGPoint(x: frame.width - t2, y: length + radius + t2))
    path.addLine(to: CGPoint(x: frame.width - t2, y: radius + t2))
    path.addArc(withCenter: CGPoint(x: frame.width - radius - t2, y: radius + t2), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
    path.addLine(to: CGPoint(x: frame.width - length - radius - t2, y: t2))
    
    // Bottom left
    path.move(to: CGPoint(x: t2, y: frame.height - length - radius - t2))
    path.addLine(to: CGPoint(x: t2, y: frame.height - radius - t2))
    path.addArc(withCenter: CGPoint(x: radius + t2, y: frame.height - radius - t2), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: false)
    path.addLine(to: CGPoint(x: length + radius + t2, y: frame.height - t2))
    
    // Bottom right
    path.move(to: CGPoint(x: frame.width - t2, y: frame.height - length - radius - t2))
    path.addLine(to: CGPoint(x: frame.width - t2, y: frame.height - radius - t2))
    path.addArc(withCenter: CGPoint(x: frame.width - radius - t2, y: frame.height - radius - t2), radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
    path.addLine(to: CGPoint(x: frame.width - length - radius - t2, y: frame.height - t2))
    
    path.lineWidth = thickness
    path.stroke()
  }
}
