import Foundation

enum APIConfig {
  /// NestJS base URL, e.g. http://127.0.0.1:3000/api/v1
  static var baseURL: URL {
    if let env = ProcessInfo.processInfo.environment["API_BASE_URL"],
       let url = URL(string: env), !env.isEmpty {
      return url
    }
    if let plist = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
       let url = URL(string: plist), !plist.isEmpty {
      return url
    }
    if let url = AppSecrets.apiBaseURL {
      return url
    }
    return URL(string: "http://127.0.0.1:3000/api/v1")!
  }

  static var syncAPIKey: String? {
    AppSecrets.syncAPIKey
  }
}
