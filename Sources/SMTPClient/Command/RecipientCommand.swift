//
//  RecipientCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct RecipientCommand: SMTPCommand, Respondable {
    public let recipientEmail: String
    
    public var value: String {
        "rcpt to:" + recipientEmail
    }
    
    public init(recipientEmail: String) {
        self.recipientEmail = recipientEmail
    }
}

