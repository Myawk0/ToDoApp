//
//  UIView.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor // Цвет тени
        layer.shadowOpacity = 0.5 // Прозрачность тени (от 0 до 1)
        layer.shadowOffset = CGSize(width: 0, height: 0) // Смещение тени
        layer.shadowRadius = 4 // Радиус размытия тени
        layer.cornerRadius = 8 // Угол скругления углов
    }
}
