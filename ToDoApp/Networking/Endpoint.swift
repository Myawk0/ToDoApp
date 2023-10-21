//
//  Endpoint.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

enum Endpoint {
    case randomCatImage

    var path: String {
        switch self {
        case .randomCatImage:
            return "/v1/images/search"
        }
    }
}
