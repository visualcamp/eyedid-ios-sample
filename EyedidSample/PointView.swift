//
//  PointView.swift
//  EyedidSample
//
//  Created by David on 10/18/24.
//

import UIKit

class PointView : UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.cornerRadius = frame.width / 2
    self.backgroundColor = .gray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
