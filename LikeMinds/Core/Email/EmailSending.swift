import Foundation

struct OutboundEmail: Sendable {
    let to: String
    let subject: String
    let htmlBody: String
    let plainTextBody: String
    let fromEmail: String
    let fromName: String
}

enum EmailSendError: LocalizedError {
    case missingAPIKey
    case invalidRecipient
    case transportFailed(String)
    case serverRejected(Int, String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "Email service is not configured (add RESEND_API_KEY)."
        case .invalidRecipient:
            "A valid email address is required."
        case .transportFailed(let detail):
            "Could not send email: \(detail)"
        case .serverRejected(let code, let detail):
            "Email provider error (\(code)): \(detail)"
        }
    }
}

protocol EmailSending: Sendable {
    func send(_ email: OutboundEmail) async throws
}
