//
//  MailFromCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct MailFromCommand: SMTPCommand, Respondable {
    public let fromEmail: String
    public var value: String {
        "MAIL FROM:" + " " + fromEmail
    }
    
    public init(fromEmail: String) {
        self.fromEmail = fromEmail
    }
}
