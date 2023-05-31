//
//  MessageDataCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct MessageDataCommand: SMTPCommand, Respondable {
    public let value = "data"
    
    public init() {}
}
