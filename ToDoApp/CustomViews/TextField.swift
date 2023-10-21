//
//  TextField.swift
//  ToDoApp
//
//  Created by Мявкo on 13.10.23.
//

import UIKit

protocol TextFieldDelegate: AnyObject {
    func deleteRowInTable()
}

class TextField: UITextField {
    
    weak var customDelegate: TextFieldDelegate?
    
    override public func deleteBackward() {
        if text == "" {
            customDelegate?.deleteRowInTable()
        }
        super.deleteBackward()
    }
}
