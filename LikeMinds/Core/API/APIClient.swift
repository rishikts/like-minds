import Foundation

enum APIError: LocalizedError {
  case invalidURL
  case missingSyncKey
  case httpStatus(Int, String?)
  case decodingFailed(Error)
  case transport(Error)

  var errorDescription: String? {
    switch self {
    case .invalidURL: "Invalid API URL"
    case .missingSyncKey: "SYNC_API_KEY is not configured in Secrets.plist"
    case let .httpStatus(code, body): "Server error (\(code)): \(body ?? "unknown")"
    case let .decodingFailed(error): "Could not read server response: \(error.localizedDescription)"
    case let .transport(error): error.localizedDescription
    }
  }
}

struct APIEnvelope<T: Decodable>: Decodable {
  let statusCode: Int
  let message: String
  let data: T?
}

final class APIClient {
  static let shared = APIClient()

  private let session: URLSession
  private let decoder: JSONDecoder

  init(session: URLSession = .shared) {
    self.session = session
    self.decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
  }

  func put<T: Decodable, B: Encodable>(
    path: String,
    body: B,
    syncKey: String? = APIConfig.syncAPIKey,
    bearerToken: String? = nil
  ) async throws -> T {
    try await request(method: "PUT", path: path, body: body, syncKey: syncKey, bearerToken: bearerToken)
  }

  func get<T: Decodable>(
    path: String,
    syncKey: String? = APIConfig.syncAPIKey,
    bearerToken: String? = nil
  ) async throws -> T {
    try await request(method: "GET", path: path, body: Optional<String>.none, syncKey: syncKey, bearerToken: bearerToken)
  }

  private func request<T: Decodable, B: Encodable>(
    method: String,
    path: String,
    body: B?,
    syncKey: String?,
    bearerToken: String?
  ) async throws -> T {
    let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
    guard let url = URL(string: trimmed, relativeTo: APIConfig.baseURL) else {
      throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    if let syncKey, !syncKey.isEmpty {
      request.setValue(syncKey, forHTTPHeaderField: "X-LikeMinds-Sync-Key")
    }
    if let bearerToken, !bearerToken.isEmpty {
      request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
    }

    if let body {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      request.httpBody = try encoder.encode(body)
    }

    do {
      let (data, response) = try await session.data(for: request)
      guard let http = response as? HTTPURLResponse else {
        throw APIError.httpStatus(-1, nil)
      }
      guard (200 ... 299).contains(http.statusCode) else {
        let text = String(data: data, encoding: .utf8)
        throw APIError.httpStatus(http.statusCode, text)
      }
      do {
        let envelope = try decoder.decode(APIEnvelope<T>.self, from: data)
        if let payload = envelope.data {
          return payload
        }
        return try decoder.decode(T.self, from: data)
      } catch {
        throw APIError.decodingFailed(error)
      }
    } catch let error as APIError {
      throw error
    } catch {
      throw APIError.transport(error)
    }
  }
}
