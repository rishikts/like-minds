import Foundation

enum EmailTemplates {
    struct SignInSuccessPayload: Sendable {
        let recipientEmail: String
        let firstName: String
        let lastName: String
        let signInMethod: String
    }

    static func signInSuccessSubject(for payload: SignInSuccessPayload) -> String {
        "You're signed in to Like Minds"
    }

    static func signInSuccessPlainText(for payload: SignInSuccessPayload) -> String {
        let greeting = payload.firstName.isEmpty ? "Hi there" : "Hi \(payload.firstName)"
        return """
        \(greeting),

        Your sign-in to Like Minds was successful.

        Sign-in method: \(payload.signInMethod)
        Email: \(payload.recipientEmail)

        You're all set to discover people who share your passions. Open the app to finish your profile and start connecting.

        — The Like Minds Team
        noreply@liveminds.com

        If you didn't sign in, please contact support@liveminds.com.
        """
    }

    static func signInSuccessHTML(for payload: SignInSuccessPayload) -> String {
        let greeting = payload.firstName.isEmpty ? "Hi there" : "Hi \(escapeHTML(payload.firstName))"
        let fullName = [payload.firstName, payload.lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Sign-in successful</title>
        </head>
        <body style="margin:0;padding:0;background:#0a0612;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
          <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background:linear-gradient(180deg,#12081f 0%,#0a0612 100%);padding:40px 16px;">
            <tr>
              <td align="center">
                <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="max-width:520px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:24px;overflow:hidden;">
                  <tr>
                    <td style="padding:36px 32px 12px;text-align:center;">
                      <div style="font-size:28px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Like Minds</div>
                      <p style="margin:8px 0 0;font-size:14px;color:rgba(255,255,255,0.55);">Where kindred spirits meet</p>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:8px 32px 0;">
                      <h1 style="margin:0;font-size:24px;line-height:1.3;color:#ffffff;font-weight:700;">Sign-in successful ✓</h1>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:16px 32px 0;">
                      <p style="margin:0;font-size:16px;line-height:1.6;color:rgba(255,255,255,0.82);">\(greeting),</p>
                      <p style="margin:16px 0 0;font-size:16px;line-height:1.6;color:rgba(255,255,255,0.72);">
                        Welcome back! Your account is ready. Continue in the app to complete your profile and find your people.
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:24px 32px;">
                      <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background:rgba(255,255,255,0.05);border-radius:16px;border:1px solid rgba(255,255,255,0.1);">
                        <tr>
                          <td style="padding:18px 20px;">
                            <p style="margin:0 0 10px;font-size:12px;text-transform:uppercase;letter-spacing:0.08em;color:rgba(255,255,255,0.45);">Account details</p>
                            \(detailRow(label: "Name", value: fullName.isEmpty ? "—" : escapeHTML(fullName)))
                            \(detailRow(label: "Email", value: escapeHTML(payload.recipientEmail)))
                            \(detailRow(label: "Signed in with", value: escapeHTML(payload.signInMethod)))
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:0 32px 32px;text-align:center;">
                      <p style="margin:0;font-size:13px;line-height:1.5;color:rgba(255,255,255,0.45);">
                        Didn't sign in? Contact <a href="mailto:support@liveminds.com" style="color:#5ce0f2;text-decoration:none;">support@liveminds.com</a>
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:20px 32px;background:rgba(0,0,0,0.25);text-align:center;border-top:1px solid rgba(255,255,255,0.08);">
                      <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.38);">© \(Calendar.current.component(.year, from: .now)) Like Minds · noreply@liveminds.com</p>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>
        """
    }

    private static func detailRow(label: String, value: String) -> String {
        """
        <p style="margin:0 0 8px;font-size:14px;line-height:1.5;color:rgba(255,255,255,0.72);">
          <span style="color:rgba(255,255,255,0.45);">\(label):</span>
          <strong style="color:#ffffff;font-weight:600;"> \(value)</strong>
        </p>
        """
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
