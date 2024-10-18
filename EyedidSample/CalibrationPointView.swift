//
//  CalibrationPointView.swift
//  EyedidSample
//
//  Created by David on 10/18/24.
//

import UIKit

class CalibrationPointView: UIView {
  private let childView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    view.alpha = 1.0
    return view
  }()

  private var originSize: CGSize = .zero
  private var prevProgress: CGFloat = .zero

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews(frame: CGRect) {
    childView.frame.size = frame.size
    childView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    childView.layer.cornerRadius = frame.width / 2
    layer.cornerRadius = frame.width / 2
    addSubview(childView)

    originSize = frame.size
    bringSubviewToFront(childView)
  }

  func movePoistion(to point: CGPoint) {
    center = point
    self.layoutIfNeeded()
  }

  func setProgress(progress: CGFloat) {
    let currentProgress = max(progress, prevProgress + 0.01)
    prevProgress = currentProgress
    let clampedProgress = max(0.0, min(1.0, currentProgress))
    let scale = 0.85 - (clampedProgress / 1.4)

    let newSize = CGSize(width: originSize.width * scale, height: originSize.height * scale)
    childView.frame.size = newSize
    childView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    childView.layer.cornerRadius = newSize.width / 2
    self.layoutIfNeeded()
  }

  func reset(to color: UIColor) {
    prevProgress = .zero
    DispatchQueue.main.async {
      self.childView.frame.size = self.originSize
      self.childView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
      self.childView.layer.cornerRadius = self.originSize.width / 2
      self.backgroundColor = color.withAlphaComponent(0.5)
      self.childView.backgroundColor = color
      self.layoutIfNeeded()
    }
  }
}
