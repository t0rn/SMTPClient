//
//  NWConnection+Concurrency.swift
//  SMTPClientDemo
//
//  Created by Alexey Ivanov on 19/5/23.
//

import Foundation
import Network

public struct Content {
    public let data: Data?
    public let context: NWConnection.ContentContext?
    public let isComplete: Bool
}

public extension NWConnection {
    var stateStream: AsyncStream<NWConnection.State> {
        AsyncStream<NWConnection.State> { continuation in
            self.stateUpdateHandler = { state in
                switch state {
                case .setup, .waiting, .preparing, .ready, .failed:
                    continuation.yield(state)
                case .cancelled:
                    continuation.yield(state)
                    continuation.finish()
                @unknown default:
                    continuation.finish()
                }
            }
        }
    }
    
    func receiveContent(
        minimumIncompleteLength: Int,
        maximumLength: Int
    ) async throws -> Content {
        try await withCheckedThrowingContinuation({ continuation in
            receive(
                minimumIncompleteLength: minimumIncompleteLength,
                maximumLength: maximumLength,
                completion: { content, context, isComplete, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let message = Content(
                        data: content,
                        context: context,
                        isComplete: isComplete
                    )
                    continuation.resume(returning: message)
                }
            )
        })
    }
    
    var receiveMessageStream: AsyncThrowingStream<Content, Error> {
        AsyncThrowingStream { continuation in
            self.receiveMessage { completeContent, contentContext, isComplete, error in
                if let error = error {
                    continuation.finish(throwing: error)
                    return
                }
                let message = Content(
                    data: completeContent,
                    context: contentContext,
                    isComplete: isComplete
                )
                continuation.yield(with: .success(message))
                if message.isComplete {
                    continuation.finish()
                }
            }
        }
    }

    func receiveContentStream(
        minimumIncompleteLength: Int,
        maximumLength: Int
    ) -> AsyncThrowingStream<Content, Error> {
        AsyncThrowingStream {
            try await self.receiveContent(
                minimumIncompleteLength: minimumIncompleteLength,
                maximumLength: maximumLength
            )
        }
    }
}
