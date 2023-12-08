//
//  String.swift
//  ToDoApp
//
//  Created by Мявкo on 8.12.23.
//

import UIKit

extension String {
    
    var makeStrikethrough: NSAttributedString {
        let attributes = [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func strikeThrough(_ isStrikeThrough: Bool = true) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        if isStrikeThrough {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: Any.self, range: NSMakeRange(0, attributeString.length))
        }
        return attributeString
    }
}
