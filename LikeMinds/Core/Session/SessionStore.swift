import Foundation
import Security

protocol SessionStoring: Sendable {
    func load() -> UserSession?
    func save(_ session: UserSession) throws
    func clear() throws
}

enum SessionStoreError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case keychainError(OSStatus)

    var errorDescription: String? {
        switch self {
        case .encodingFailed: "Could not save your session."
        case .decodingFailed: "Could not restore your session."
        case .keychainError: "Secure storage is unavailable right now."
        }
    }
}

/// Persists session metadata in UserDefaults and tokens in Keychain (Supabase-ready).
final class SessionStore: SessionStoring, @unchecked Sendable {
    private let defaults: UserDefaults
    private let sessionKey = "com.likeminds.session"
    private let tokenService = "com.likeminds.auth.tokens"
    private let tokenAccount = "primary"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> UserSession? {
        guard let data = defaults.data(forKey: sessionKey) else { return nil }
        guard var session = try? JSONDecoder().decode(UserSession.self, from: data) else {
            return nil
        }
        if session.accessToken == nil, let token = readTokenFromKeychain() {
            session.accessToken = token
        }
        return session
    }

    func save(_ session: UserSession) throws {
        var sessionToPersist = session
        if let token = session.accessToken {
            try saveTokenToKeychain(token)
            sessionToPersist.accessToken = nil
        }
        guard let data = try? JSONEncoder().encode(sessionToPersist) else {
            throw SessionStoreError.encodingFailed
        }
        defaults.set(data, forKey: sessionKey)
    }

    func clear() throws {
        defaults.removeObject(forKey: sessionKey)
        deleteTokenFromKeychain()
    }

    // MARK: - Keychain

    private func saveTokenToKeychain(_ token: String) throws {
        guard let data = token.data(using: .utf8) else { return }
        deleteTokenFromKeychain()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: tokenService,
            kSecAttrAccount as String: tokenAccount,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SessionStoreError.keychainError(status)
        }
    }

    private func readTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: tokenService,
            kSecAttrAccount as String: tokenAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8)
        else { return nil }
        return token
    }

    @discardableResult
    private func deleteTokenFromKeychain() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: tokenService,
            kSecAttrAccount as String: tokenAccount
        ]
        return SecItemDelete(query as CFDictionary)
    }
}
