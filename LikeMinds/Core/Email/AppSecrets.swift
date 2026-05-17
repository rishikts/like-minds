import Foundation

enum AppSecrets {
    static var resendAPIKey: String? {
        if let env = ProcessInfo.processInfo.environment["RESEND_API_KEY"], !env.isEmpty {
            return env
        }
        if let plist = Bundle.main.object(forInfoDictionaryKey: "RESEND_API_KEY") as? String, !plist.isEmpty {
            return plist
        }
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
           let key = dict["RESEND_API_KEY"] as? String, !key.isEmpty {
            return key
        }
        return nil
    }

    static let defaultFromEmail = "noreply@liveminds.com"
    static let defaultFromName = "Like Minds"

    static var fromEmail: String {
        (Bundle.main.object(forInfoDictionaryKey: "EMAIL_FROM_ADDRESS") as? String)
            ?? defaultFromEmail
    }

    static var fromName: String {
        (Bundle.main.object(forInfoDictionaryKey: "EMAIL_FROM_NAME") as? String)
            ?? defaultFromName
    }
}
