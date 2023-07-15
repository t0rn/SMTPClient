# SMTPClient
Swift SMTPClient using Network framework and Concurrency 
 
## Usage
```swift
let client = SMTPClient(
    host: "smtp.exampe.com",
    port: 465
)

func sendEmail() async throws {
    client.connect()
    Task {
        for try await state in client.connectionState {
            print(state)
        }
    }
    try await client.send(EhloCommand(domain: "smtp.exampe.com"))
    try await client.send(AuthCommand())
    try await client.send(AuthLogin(login: "LOGIN"))
    try await client.send(AuthPassword(password: "PASSWORD"))
    try await client.send(MailFromCommand(fromEmail: "from@example.com"))
    try await client.send(RecipientCommand(recipientEmail: "to@example.com"))
    try await client.send(MessageDataCommand())
    try await client.send(SubjectCommand(subjectText: "Hello subject"))
    try await client.send(Command(value: "message body text here "))
    try await client.send(EndMessageCommand())
    client.disconnect()
}
try await sendEmail()
```
# Installation

### Swift Package Manager
