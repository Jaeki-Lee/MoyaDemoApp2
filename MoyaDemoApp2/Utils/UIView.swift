//
//  UIView.swift
//  MoyaDemoApp2
//
//  Created by trost.jk on 2022/07/20.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
      subviews.forEach(self.addSubview)
    }
}
