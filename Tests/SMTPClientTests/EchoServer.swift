//
//  File.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation
import Network

class EchoServer {
    typealias Echo = (Data) -> Data
    
    let networkQueue = DispatchQueue(label: "SMTPClient.echoServer.queue")
    let echo: Echo
    private(set) var listener : NWListener
    
    init(
        _ port: NWEndpoint.Port,
        echo: @escaping Echo = EchoServer.defaultEcho(received: )
    ) throws {
        self.listener = try NWListener(using: .tcp, on: port)
        self.echo = echo
    }
    
    func run() {
        setupListener()
    }
    
    private func setupListener() {
        listener.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Listener ready on \(String(describing: self.listener.port))")
            case .failed(let error):
                print("Listener failed with \(error), restarting")
                self.listener.cancel()
            default:
                break
            }
        }
        listener.newConnectionHandler = handle(connection: )
        listener.start(queue: networkQueue)
    }
    
    private func handle(connection: NWConnection) {
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                self.readData(of: connection)
            case .failed(let error):
                print("state failed \(error)")
                connection.cancel()
            case .cancelled:
                print("\(connection) cancelled")
            default:
                break
            }
        }
        connection.start(queue: self.networkQueue)
    }
    
    private func readData(of connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { (content, context, isComplete, error) in
            
            if let receivedData = content, !receivedData.isEmpty {
                let echo = self.echo(receivedData)
                connection.send(content: echo, completion: .idempotent)
            }
            if let error = error {
                print("\(connection) error - ", error.localizedDescription)
                return
            }
            self.readData(of: connection)
        }
    }
}

extension EchoServer {
    class func defaultEcho(received data: Data) -> Data {
        data
    }
}
