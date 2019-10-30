//
//  CrowdinRemoteLocalizationStorage.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 3/27/19.
//

import Foundation

public let CrowdinProviderDidDownloadLocalization = Notifications.CrowdinProviderDidDownloadLocalization.rawValue
public let CrowdinProviderDownloadError = Notifications.CrowdinProviderDownloadError.rawValue

extension Notification.Name {
    public static let CrowdinProviderDidDownloadLocalization = Notification.Name(Notifications.CrowdinProviderDidDownloadLocalization.rawValue)
    public static let CrowdinProviderDownloadError = Notification.Name(Notifications.CrowdinProviderDownloadError.rawValue)
}

class CrowdinRemoteLocalizationStorage: RemoteLocalizationStorageProtocol {
    var localizations: [String]
    var hashString: String
    var stringsFileNames: [String]
    var pluralsFileNames: [String]
    var name: String = "Crowdin"
    
    private let crowdinDownloader: CrowdinDownloaderProtocol
    
    init(config: CrowdinProviderConfig, enterprise: Bool) {
        self.hashString = config.hashString
        self.stringsFileNames = config.stringsFileNames
        self.pluralsFileNames = config.pluralsFileNames
        self.localizations = config.localizations
        self.crowdinDownloader = CrowdinLocalizationDownloader(enterprise: enterprise)
    }
    
    required init(enterprise: Bool) {
        self.crowdinDownloader = CrowdinLocalizationDownloader(enterprise: enterprise)
        guard let hashString = Bundle.main.crowdinHash else {
            fatalError("Please add CrowdinHash key to your Info.plist file")
        }
        self.hashString = hashString
        guard let localizations = Bundle.main.cw_localizations else {
            fatalError("Please add CrowdinLocalizations key to your Info.plist file")
        }
        self.localizations = localizations
        guard let crowdinStringsFileNames = Bundle.main.crowdinStringsFileNames else {
            fatalError("Please add CrowdinStringsFileNames key to your Info.plist file")
        }
        self.stringsFileNames = crowdinStringsFileNames
        guard let crowdinPluralsFileNames = Bundle.main.crowdinPluralsFileNames else {
            fatalError("Please add CrowdinPluralsFileNames key to your Info.plist file")
        }
        self.pluralsFileNames = crowdinPluralsFileNames
    }
    
    func fetchData(for localization: String, completion: @escaping LocalizationStorageCompletion) {
        self.crowdinDownloader.download(strings: stringsFileNames, plurals: pluralsFileNames, with: hashString, for: localization) { [weak self] strings, plurals, errors in
        DispatchQueue.main.async {
            guard let self = self else { return }
            completion(localization, self.localizations, strings, plurals)
                if let currentLocalization = CrowdinSDK.currentLocalization, currentLocalization == localization {
                    NotificationCenter.default.post(Notification(name: Notification.Name.CrowdinProviderDidDownloadLocalization))
                    
                    if let errors = errors {
                        NotificationCenter.default.post(name: Notification.Name.CrowdinProviderDownloadError, object: errors)
                    }
                }
            }
        }
    }
    
    /// Remove add stored E-Tag headers for every file.
    func deintegrate() {
        for supportedLocalization in localizations {
            self.stringsFileNames.forEach({
                let filePath = CrowdinPathsParser.shared.parse($0, localization: supportedLocalization)
                UserDefaults.standard.removeObject(forKey: filePath)
            })
            self.pluralsFileNames.forEach({
                let filePath = CrowdinPathsParser.shared.parse($0, localization: supportedLocalization)
                UserDefaults.standard.removeObject(forKey: filePath)
            })
        }
        UserDefaults.standard.synchronize()
    }
}
