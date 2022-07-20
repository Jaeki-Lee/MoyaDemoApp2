//
//  String.swift
//  MoyaDemoApp2
//
//  Created by trost.jk on 2022/07/20.
//

import Foundation

extension String {
    var removedEscapeCharacters: String {
        /// remove: \"
        let removedEscapeWithQuotationMark = self.replacingOccurrences(of: "\\\"", with: "")
        /// remove: \
        let removedEscape = removedEscapeWithQuotationMark.replacingOccurrences(of: "\\", with: "")
        return removedEscape
    }
}
