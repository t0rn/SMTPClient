//
//  EhloCommand.swift
//
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct EhloCommand: SMTPCommand, Respondable {
    public let domain: String
    public var value: String {
        "ehlo \(domain)"
    }
    
    public init(domain: String) {
        self.domain = domain
    }
}
