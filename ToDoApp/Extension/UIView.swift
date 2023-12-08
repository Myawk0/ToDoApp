//
//  UIView.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.cornerRadius = 8
    }
    
    func getAttributedTitle(with title: String) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
