//
//  Renderable.swift
//  PenguinPayApp
//
//  Created by Josué Cadillo on 06-12-21.
//

import UIKit

protocol Renderable { // for render views
    func render<T: UIView>(fromView customView: T)
}

extension Renderable {
    func render<T: UIView>(fromView customView: T) {
        render(fromView: customView, bundle: .main)
    }
    func render<T: UIView>(fromView customView: T, bundle: Bundle?) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: customView, options: nil)[0] as! UIView
        view.frame = customView.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        customView.addSubview(view)
    }
}
