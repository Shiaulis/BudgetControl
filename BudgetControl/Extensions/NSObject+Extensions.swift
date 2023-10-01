//
//  NSObject+Extensions.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import Foundation

extension NSObject {
    static var classFullName: String {
        String(reflecting: self)
    }

    static var className: String {
        String(describing: self)
    }

    var classFullName: String {
        type(of: self).classFullName
    }

    var className: String {
        type(of: self).className
    }
}
