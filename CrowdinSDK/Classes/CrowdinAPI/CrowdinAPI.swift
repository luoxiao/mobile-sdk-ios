//
//  CrowdinAPI.swift
//  CrowdinAPI
//
//  Created by Serhii Londar on 3/16/19.
//

import Foundation

protocol CrowdinAuth {
    var accessToken: String? { get }
}

extension Notification.Name {
    public static let CrowdinAPIUnautorizedNotification = Notification.Name("CrowdinAPIUnautorizedNotification")
}

class CrowdinAPI: BaseAPI {
    let organizationName: String?
    let auth: CrowdinAuth?
    var baseURL: String {
        if let organizationName = organizationName {
            return "https://\(organizationName).crowdin.com/api/v2/"
        }
        return "https://crowdin.com/api/v2/"
    }
    
    var apiPath: String {
        return .empty
    }
    
    var fullPath: String {
        return baseURL + apiPath
    }
    
    init(organizationName: String? = nil, auth: CrowdinAuth? = nil, session: URLSession = .shared) {
        self.organizationName = organizationName
        self.auth = auth
        super.init(session: session)
    }
    
    func cw_post<T: Decodable>(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, body: Data?, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.post(url: url, parameters: parameters, headers: authorized(headers), body: body, completion: { data, response, error in
            if self.isUnautorized(response: response) {
                NotificationCenter.default.post(name: .CrowdinAPIUnautorizedNotification, object: nil)
                return;
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response, error)
            } catch {
                print(String(data: data, encoding: .utf8) ?? "Data is empty")
                completion(nil, error)
            }
        })
    }
    
    func cw_post<T: Decodable>(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, body: Data?) -> (T?, Error?) {
        let result = self.post(url: url, parameters: parameters, headers: authorized(headers), body: body)
        if self.isUnautorized(response: result.response) {
            NotificationCenter.default.post(name: .CrowdinAPIUnautorizedNotification, object: nil)
            return (nil, nil);
        }
        guard let data = result.data else {
            return (nil, result.error)
        }
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return (response, result.error)
        } catch {
            print(String(data: data, encoding: .utf8) ?? "Data is empty")
            return (nil, error)
        }
    }
    
    func cw_get<T: Decodable>(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (T?, Error?) -> Swift.Void) {
        self.get(url: url, parameters: parameters, headers: authorized(headers), completion: { data, response, error in
            if self.isUnautorized(response: response) {
                NotificationCenter.default.post(name: .CrowdinAPIUnautorizedNotification, object: nil)
                return;
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response, error)
            } catch {
                print(String(data: data, encoding: .utf8) ?? "Data is empty")
                completion(nil, error)
            }
        })
    }
    
    func cw_get<T: Decodable>(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil) -> (T?, Error?) {
        let result = self.get(url: url, parameters: parameters, headers: authorized(headers))
        if self.isUnautorized(response: result.response) {
            NotificationCenter.default.post(name: .CrowdinAPIUnautorizedNotification, object: nil)
            return (nil, nil);
        }
        guard let data = result.data else {
            return (nil, result.error)
        }
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return (response, result.error)
        } catch {
            print(String(data: data, encoding: .utf8) ?? "Data is empty")
            return (nil, error)
        }
    }
    
    func authorized(_ headers: [String: String]?) -> [String: String] {
        var result = headers ?? [:]
        guard let accessToken = auth?.accessToken else { return result }
        result["Authorization"] = "Bearer \(accessToken)"
        return result
    }
    
    func isUnautorized(response: URLResponse?) -> Bool {
        if let code = (response as? HTTPURLResponse)?.statusCode, code == 401 {
            return true
        }
        return false
    }
}
