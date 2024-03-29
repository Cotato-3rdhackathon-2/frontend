//
//  Bundle+Extension.swift
//
//
//  Created by 최준영 on 2024/01/05.
//

import Foundation

public extension Bundle {
    /// Return - String
    func provideFilePath(name: String, ext: String) -> String {
        guard let path = self.path(forResource: name, ofType: ext) else {
            preconditionFailure("can't find resource in this Bundle")
        }
        return path
    }
}
