//
//  SMTPCommand.swift
//
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public protocol SMTPCommand {
    var value: String { get }
}

public struct Command: SMTPCommand, Respondable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
}
