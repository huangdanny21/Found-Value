//
//  UIView+Additions.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import UIKit

extension UIView {
  func smoothRoundCorners(to radius: CGFloat) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: radius
    ).cgPath

    layer.mask = maskLayer
  }
}
