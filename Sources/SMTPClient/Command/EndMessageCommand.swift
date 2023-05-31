//
//  EndMessageCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct EndMessageCommand: SMTPCommand, Respondable {
    public let value = "."
    public init() { }
}
