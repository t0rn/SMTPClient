//
//  AuthCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct AuthCommand: SMTPCommand, Respondable {
    public let value = "AUTH LOGIN"
    public init() {}
}

public struct AuthLogin: SMTPCommand, Respondable {
    public let login: String
    
    public var value: String {
        Data(login.utf8).base64EncodedString()
    }
    
    public init(login: String) {
        self.login = login
    }
}

public struct AuthPassword: SMTPCommand, Respondable {
    public let password: String
    
    public var value: String {
        Data(password.utf8).base64EncodedString()
    }
    
    init(password: String) {
        self.password = password
    }
}
