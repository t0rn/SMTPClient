import XCTest
import Network
@testable import SMTPClient

final class SMTPClientTests: XCTestCase {
    let host = "localhost"
    let port = 465
    var client: SMTPClient!
    var echoServer: EchoServer!
    
    override func setUp() {
        client = SMTPClient(
            host: host,
            port: port,
            parameters: .tcp
        )
        let serverPort = NWEndpoint.Port(rawValue: UInt16(port))!
        echoServer = try! EchoServer(
            serverPort,
            echo: EchoServer.defaultSuccessSMTPEcho(received: )
        )
        echoServer.run()
        Task {
            for try await state in client.connectionState {
                print(state)
            }
        }
    }
    
    func testSendEmail() async throws {
        client.connect()
        try await client.send(EhloCommand(domain: "smtp.mail.ru"))
        try await client.send(AuthCommand())
        try await client.send(AuthLogin(login: "-LOGIN-"))
        try await client.send(AuthPassword(password: "password"))
        try await client.send(MailFromCommand(fromEmail: "from@example.com"))
        try await client.send(RecipientCommand(recipientEmail: "recipient@example.com"))
        try await client.send(MessageDataCommand())
        try await client.send(SubjectCommand(subjectText: "Hello subject"))
        try await client.send(Command(value: "test text here "))
        try await client.send(EndMessageCommand())
    }
    
    func testCommand() async throws {
        client.connect()
        try await client.send(EhloCommand(domain: host))
    }
    
    func testCommands() async throws {
        let commands: [SMTPCommand & Respondable] = [
            EhloCommand(domain: host),
            AuthCommand()
        ]
        client.connect()
        let responses = try await client.send(commands,delay: .zero)
        let ok = responses.allSatisfy(\.statusCode.isPositive)
        XCTAssertTrue(ok)
    }
    
    func testResponseStream() async throws {
        let commands: [SMTPCommand & Respondable] = [
            EhloCommand(domain: host),
            AuthCommand()
        ]
        client.connect()
        let allPositive = try await client
            .responseStream(commands)
            .allSatisfy { response in
                return response.statusCode.isPositive
            }
        XCTAssertTrue(allPositive)
    }
}

