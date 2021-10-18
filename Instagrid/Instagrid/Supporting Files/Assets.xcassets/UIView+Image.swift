//
//  UIView+Image.swift
//  Instagrid
//
//  Created by Déborah Suon on 17/05/2021.
//


import UIKit

extension UIView {
    /// Transform a view to image
    var image: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
}
