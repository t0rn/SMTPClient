//
//  Response.swift
//  SMTPClientDemo
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct Response {
    public typealias StatusCode = Int
    
    public let statusCode: StatusCode
    public let message: String?
}

public extension Response {
    enum InitError: Error {
        case wrongData
        case unknowStatusCode
    }
        
    init(_ data: Data) throws {
        guard
            let message = String(data: data, encoding: .utf8)
        else { throw InitError.wrongData }
        
        try self.init(message: message)
    }
    
    init(message: String) throws {
        guard
            let statusCode = StatusCode(message.prefix(3))
        else { throw InitError.unknowStatusCode }
        self.init(statusCode: statusCode, message: message)
    }
}

public extension Response {
    enum ValidationError: Error {
        case invalidStatusCode
    }
}

public extension Response.StatusCode {
    //source
    //https://www.socketlabs.com/blog/what-does-smtp-error-mean/
    //https://www.socketlabs.com/blog/21-smtp-response-codes-that-you-need-to-know/#:~:text=220%20—%20SMTP%20Service%20ready.,forward%20with%20the%20next%20command.
    static let ready = 220
    static let closing = 221
    static let actionRequest = 250
    static let authSucceeded = 235
    
    static let provideAuthCredentials = 335
    
    var isPositive: Bool {
        (200...399).contains(self)
    }
}

public extension Response {
    init(_ message: Content) throws {
        guard let data = message.data else {
            throw InitError.wrongData
        }
        try self.init(data)
    }
}
