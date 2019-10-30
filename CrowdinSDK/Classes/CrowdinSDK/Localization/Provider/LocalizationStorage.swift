//
//  LocalizationStorage.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 6/3/19.
//

import Foundation

/// Closure with localization data. Contains list of all available languages, strings and plurals localizations.
public typealias LocalizationStorageCompletion = (_ localization: String, _ localizations: [String]?, _ strings: [String: String]?, _ plurals: [AnyHashable: Any]?) -> Void

/// Protocol for storage with localization data.
@objc public protocol LocalizationStorageProtocol {
    /// Method for data fetching.
    ///
    /// - Parameter completion: Completion block called after localization data fetched.
    func fetchData(for localization: String, completion: @escaping LocalizationStorageCompletion)
}
