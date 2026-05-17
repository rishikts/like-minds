import Foundation

struct GooglePeopleProfile: Sendable {
    var phoneNumber: String?
}

/// Fetches optional phone number via Google People API after OAuth.
final class GooglePeopleProfileService: Sendable {
    func fetchProfile(accessToken: String) async -> GooglePeopleProfile {
        guard let phone = await fetchPrimaryPhoneNumber(accessToken: accessToken) else {
            return GooglePeopleProfile(phoneNumber: nil)
        }
        return GooglePeopleProfile(phoneNumber: phone)
    }

    private func fetchPrimaryPhoneNumber(accessToken: String) async -> String? {
        var components = URLComponents(string: "https://people.googleapis.com/v1/people/me")!
        components.queryItems = [
            URLQueryItem(name: "personFields", value: "phoneNumbers")
        ]
        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return nil
            }
            return Self.parsePhoneNumber(from: data)
        } catch {
            return nil
        }
    }

    private static func parsePhoneNumber(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let numbers = json["phoneNumbers"] as? [[String: Any]],
              !numbers.isEmpty
        else { return nil }

        if let primary = numbers.first(where: { ($0["metadata"] as? [String: Any])?["primary"] as? Bool == true }),
           let value = primary["value"] as? String, !value.isEmpty {
            return value
        }
        return numbers.compactMap { $0["value"] as? String }.first { !$0.isEmpty }
    }
}
