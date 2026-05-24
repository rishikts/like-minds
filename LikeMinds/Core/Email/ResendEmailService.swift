import Foundation

/// Sends transactional email via [Resend](https://resend.com) — verify `liveminds.com` and add `RESEND_API_KEY`.
final class ResendEmailService: EmailSending, Sendable {
    private let session: URLSession
    private let apiKeyProvider: @Sendable () -> String?

    init(
        session: URLSession = .shared,
        apiKeyProvider: @escaping @Sendable () -> String? = { AppSecrets.resendAPIKey }
    ) {
        self.session = session
        self.apiKeyProvider = apiKeyProvider
    }

    func send(_ email: OutboundEmail) async throws {
        guard let apiKey = apiKeyProvider(), !apiKey.isEmpty else {
            throw EmailSendError.missingAPIKey
        }
        guard email.to.contains("@") else {
            throw EmailSendError.invalidRecipient
        }

        let from = "\(email.fromName) <\(email.fromEmail)>"
        let payload: [String: Any] = [
            "from": from,
            "to": [email.to],
            "subject": email.subject,
            "html": email.htmlBody,
            "text": email.plainTextBody
        ]

        var request = URLRequest(url: URL(string: "https://api.resend.com/emails")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw EmailSendError.transportFailed(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw EmailSendError.transportFailed("Invalid response")
        }

        guard (200...299).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw EmailSendError.serverRejected(http.statusCode, message)
        }
    }
}
