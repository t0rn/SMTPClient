import Foundation
import Network

open class SMTPClient {
    public typealias ConnectionState = String
    
    public let queue: DispatchQueue
    private let connection: NWConnection
    
    public private(set) lazy var connectionState: some AsyncSequence = {
        connection
            .stateStream
            .map { state in
                String(describing: state)
            }
    }()
    
    public init(
        connection: NWConnection,
        queue: DispatchQueue
    ) {
        self.connection = connection
        self.queue = queue
    }
    
    public convenience init(
        host: String,
        port: Int,
        parameters: NWParameters = .TLSv12,
        queue: DispatchQueue = DispatchQueue(label: "com.SMTPClient.connectionQ")
    ) {
        let connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: NWEndpoint.Port(rawValue: UInt16(port))!,
            using: parameters
        )
        self.init(connection: connection, queue: queue)
    }
    
    open func connect() {
        connection.start(queue: queue)
    }
    
    open func send<Command>(
        _ command: Command
    ) async throws where Command: SMTPCommand {
        try await connection.send(command: command)
    }
    
    @discardableResult
    open func send<Command>(
        _ command: Command
    )
    async throws -> Response
    where Command: SMTPCommand & Respondable
    {
        try await connection.send(command: command)
        let content = try await connection.receiveContent(minimumIncompleteLength: 1, maximumLength: 1024)
        return try handle(content, for: command)
    }
    
    open func handle<Command>(
        _ content: Content,
        for command: Command
    )
    throws -> Response
    where Command: SMTPCommand
    {
        let response = try Response(content)
        guard response.statusCode.isPositive else {
            throw Response.ValidationError.invalidStatusCode
        }
        return response
    }
    
    open func send(
        _ commands: [SMTPCommand & Respondable],
        delay: Duration = .seconds(1)
    ) async throws -> [Response] {
        var result = [Response]()
        for command in commands {
            let response = try await send(command)
            result.append(response)
            try await Task.sleep(for: delay)
        }
        return result
    }
    
    open func responseStream(
        _ commands: [SMTPCommand & Respondable],
        delay: Duration = .zero
    ) -> AsyncThrowingStream<Response, Error> {
        AsyncThrowingStream { contunuation in
            Task {
                for command in commands {
                    do {
                        let response = try await send(command)
                        try await Task.sleep(for: delay)
                        contunuation.yield(response)
                    }catch {
                        contunuation.yield(with: .failure(error))
                    }
                    //doesn't throw error in case of error
//                    let response = try await send(command)
//                    try await Task.sleep(for: delay)
//                    contunuation.yield(response)
                }
                contunuation.finish()
            }
        }
    }
    
    open func disconnect() {
        guard connection.state != .cancelled else { return }
        connection.forceCancel()
    }
}
