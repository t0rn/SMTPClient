//
//  NWConnection+SMTPCommandProtocol.swift
//  SMTPClientDemo
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation
import Network

public extension NWConnection {
    func send(
        command: SMTPCommand,
        contentContext: ContentContext = .defaultMessage,
        isComplete: Bool = true
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            send(
                command: command,
                contentContext: contentContext,
                isComplete: isComplete,
                completion: { error in
                    if let error = error {
                        continuation.resume(with: .failure(error))
                        return
                    }
                    continuation.resume()
                }
            )
        }
    }
        
    func send(
        command: SMTPCommand,
        contentContext: ContentContext = .defaultMessage,
        isComplete: Bool = true,
        completion: @escaping ((Error?) -> Void)
    ) {
        let data = Data("\(command.value)\r\n".utf8)
        send(
            content: data,
            contentContext: contentContext,
            isComplete: isComplete,
            completion: .contentProcessed({ error in
                completion(error)
            })
        )
    }
}
