//
//  CrowdinDownloader.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 3/24/19.
//

import Foundation

class CrowdinLocalizationDownloader: CrowdinDownloaderProtocol {
    // swiftlint:disable implicitly_unwrapped_optional
    var completion: CrowdinDownloaderCompletion!
    
    fileprivate var operationQueue = OperationQueue()
    fileprivate var strings: [String: String]? = nil
    fileprivate var plurals: [AnyHashable: Any]? = nil
    fileprivate var errors: [Error]? = nil
    fileprivate var contentDeliveryAPI: CrowdinContentDeliveryAPI!
    fileprivate var enterprise: Bool
    
    init(enterprise: Bool) {
        self.enterprise = enterprise
    }
    
    func download(strings: [String], plurals: [String], with hash: String, for localization: String, completion: @escaping CrowdinDownloaderCompletion) {
        print("downloading - \(localization)")
        operationQueue.cancelAllOperations()
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        self.contentDeliveryAPI = CrowdinContentDeliveryAPI(hash: hash, enterprise: enterprise, session: URLSession.init(configuration: .ephemeral))
		self.strings = nil
		self.plurals = nil
		self.errors = nil
		
        self.completion = completion
        let completionBlock = BlockOperation {
            print("self.completion(self.strings, self.plurals, self.errors) - \(localization)")
            self.completion(self.strings, self.plurals, self.errors)
        }
        
        strings.forEach { (string) in
            let download = CrowdinStringsDownloadOperation(hash: hash, filePath: string, localization: localization, contentDeliveryAPI: contentDeliveryAPI)
            download.completion = { (strings, error) in
                if let error = error {
                    if self.errors != nil {
                        self.errors?.append(error)
                    } else {
                        self.errors = [error]
                    }
                }
                guard let strings = strings else { return }
                if self.strings != nil {
                    self.strings?.merge(with: strings)
                } else {
                    self.strings = strings
                }
            }
            completionBlock.addDependency(download)
            operationQueue.addOperation(download)
        }
        
        plurals.forEach { (plural) in
            let download = CrowdinPluralsDownloadOperation(hash: hash, filePath: plural, localization: localization, contentDeliveryAPI: contentDeliveryAPI)
            download.completion = { (plurals, error) in
                if let error = error {
                    if self.errors != nil {
                        self.errors?.append(error)
                    } else {
                        self.errors = [error]
                    }
                }
                guard let plurals = plurals else { return }
                if self.plurals != nil {
                    self.plurals?.merge(with: plurals)
                } else {
                    self.plurals = plurals
                }
            }
            completionBlock.addDependency(download)
            operationQueue.addOperation(download)
        }
        operationQueue.addOperation(completionBlock)
    }
    
    deinit {
        print("deinit")
    }
}
