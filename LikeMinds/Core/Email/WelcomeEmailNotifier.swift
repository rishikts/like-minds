import Foundation
import os

protocol WelcomeEmailNotifying: Sendable {
    func sendSignInSuccessEmail(for user: AuthUser) async
}

/// Sends the standard post-sign-in email (non-blocking for auth; failures are logged).
final class WelcomeEmailNotifier: WelcomeEmailNotifying, Sendable {
    private let emailService: EmailSending
    private let logger = Logger(subsystem: "com.rishikts.likeminds", category: "WelcomeEmail")

    init(emailService: EmailSending = ResendEmailService()) {
        self.emailService = emailService
    }

    func sendSignInSuccessEmail(for user: AuthUser) async {
        guard user.provider == .google,
              let recipient = user.email,
              !recipient.isEmpty
        else { return }

        let payload = EmailTemplates.SignInSuccessPayload(
            recipientEmail: recipient,
            firstName: user.firstName ?? "",
            lastName: user.lastName ?? "",
            signInMethod: "Google"
        )

        let outbound = OutboundEmail(
            to: recipient,
            subject: EmailTemplates.signInSuccessSubject(for: payload),
            htmlBody: EmailTemplates.signInSuccessHTML(for: payload),
            plainTextBody: EmailTemplates.signInSuccessPlainText(for: payload),
            fromEmail: AppSecrets.fromEmail,
            fromName: AppSecrets.fromName
        )

        do {
            try await emailService.send(outbound)
            logger.info("Sign-in success email sent to \(recipient, privacy: .private)")
        } catch {
            logger.error("Sign-in email failed: \(error.localizedDescription, privacy: .public)")
        }
    }
}
