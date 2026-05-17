import Foundation

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

/// Loads the Google OAuth iOS client ID and configures `GIDSignIn`.
enum GoogleSignInConfiguration {
    /// Human-readable setup steps shown when configuration is missing.
    static let setupInstructions = """
    Google Sign-In is not configured. In Terminal, from the LikeMinds folder run:
    ./scripts/setup-google-oauth.sh
    Then Clean Build (⇧⌘K) and run again.
    """

    /// Resolves the iOS client ID from bundled configuration files.
    static func resolveClientID() -> String? {
        if let id = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String,
           !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return id
        }

        if let id = googleServiceInfoValue(forKey: "CLIENT_ID"), !id.isEmpty {
            return id
        }

        if let id = secretsValue(forKey: "GOOGLE_CLIENT_ID"), !id.isEmpty {
            return id
        }

        if let env = ProcessInfo.processInfo.environment["GOOGLE_CLIENT_ID"],
           !env.isEmpty {
            return env
        }

        return nil
    }

    /// Configures the shared `GIDSignIn` instance. Returns `false` if no client ID was found.
    @discardableResult
    static func configure() -> Bool {
        #if canImport(GoogleSignIn)
        guard let clientID = resolveClientID() else {
            return false
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        return true
        #else
        return false
        #endif
    }

    /// Ensures Google Sign-In is configured, throwing a descriptive error if not.
    static func configureOrThrow() throws {
        guard configure() else {
            throw AuthError.missingConfiguration(Self.setupInstructions)
        }
    }

    // MARK: - Private

    private static func googleServiceInfoValue(forKey key: String) -> String? {
        guard let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let value = plist[key] as? String
        else { return nil }
        return value
    }

    private static func secretsValue(forKey key: String) -> String? {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let value = plist[key] as? String
        else { return nil }
        return value
    }
}
