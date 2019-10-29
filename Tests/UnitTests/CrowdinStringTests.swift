//
//  StringsTest.swift
//  TestsTests
//
//  Created by Serhii Londar on 13.10.2019.
//  Copyright © 2019 Serhii Londar. All rights reserved.
//

import XCTest
@testable import CrowdinSDK

class CrowdinStringTestsEnLocalization: XCTestCase {
    var downloadCount = 0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let crowdinProviderConfig = CrowdinProviderConfig(hashString: "5290b1cfa1eb44bf2581e78106i",
                                                          stringsFileNames: ["Localizable.strings", "Main.strings"],
                                                          pluralsFileNames: ["Localizable.stringsdict"],
                                                          localizations: ["en", "de", "uk"],
                                                          sourceLanguage: "en")
        let crowdinSDKConfig = CrowdinSDKConfig.config().with(crowdinProviderConfig: crowdinProviderConfig)
        
        CrowdinSDK.startWithConfig(crowdinSDKConfig)
        CrowdinSDK.deintegrate()
        
        sleep(2)
    }
    
    
    override func tearDown() {
        downloadCount = 0
        CrowdinSDK.removeAllDownloadHandlers()
        CrowdinSDK.deintegrate()
        CrowdinSDK.stop()
    }
    
    func testCrowdinSDKStringLocalizationForDefaultLanguage() {
        CrowdinSDK.enableSDKLocalization(true, localization: nil)
        let expectation = XCTestExpectation(description: "Download handler is called")
        
        _ = CrowdinSDK.addDownloadHandler {
            self.downloadCount += 1
            if self.downloadCount == 2 {
                print("test_key".cw_localized)
                XCTAssert("test_key".cw_localized == "test_value [C]")
                XCTAssert("test_key_with_string_parameter".cw_localized(with: ["value"]) == "test value with parameter - value [C]")
                XCTAssert("test_key_with_int_parameter".cw_localized(with: [1]) == "test value with parameter - 1 [C]")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 60.0)
        XCTAssert(self.downloadCount == 2, "Download handler should be called twice")
    }
    
    func testCrowdinSDKStringLocalizationForDeLanguage() {
        CrowdinSDK.enableSDKLocalization(true, localization: "de")
        
        let expectation = XCTestExpectation(description: "Download handler is called")
        
        _ = CrowdinSDK.addDownloadHandler {
            self.downloadCount += 1
            if self.downloadCount == 2 {
                print("test_key".cw_localized)
                XCTAssert("test_key".cw_localized == "Testwert [C]")
                XCTAssert("test_key_with_string_parameter".cw_localized(with: ["value"]) == "Testwert mit Parameter - value [C]")
                XCTAssert("test_key_with_int_parameter".cw_localized(with: [1]) == "Testwert mit Parameter - 1 [C]")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 60.0)
        XCTAssert(self.downloadCount == 2, "Download handler should be called twice")
    }
    
    func testCrowdinSDKStringLocalizationForUkLanguage() {
        CrowdinSDK.enableSDKLocalization(true, localization: "uk")
        let expectation = XCTestExpectation(description: "Download handler is called")
        
        _ = CrowdinSDK.addDownloadHandler {
            self.downloadCount += 1
            if self.downloadCount == 2 {
                print("test_key".cw_localized)
                XCTAssert("test_key".cw_localized == "Тестове значення [C]")
                XCTAssert("test_key_with_string_parameter".cw_localized(with: ["value"]) == "значення тесту з параметром - value [C]")
                XCTAssert("test_key_with_int_parameter".cw_localized(with: [1]) == "значення тесту з параметром - 1 [C]")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 60.0)
        XCTAssert(self.downloadCount == 2, "Download handler should be called twice")
    }
    
    func testCrowdinSDKStringLocalizationForEnLanguage() {
        CrowdinSDK.enableSDKLocalization(true, localization: "en")
        
        let expectation = XCTestExpectation(description: "Download handler is called")
        
        _ = CrowdinSDK.addDownloadHandler {
            self.downloadCount += 1
            if self.downloadCount == 2 {
                print("test_key".cw_localized)
                XCTAssert("test_key".cw_localized == "test_value [C]")
                XCTAssert("test_key_with_string_parameter".cw_localized(with: ["value"]) == "test value with parameter - value [C]")
                XCTAssert("test_key_with_int_parameter".cw_localized(with: [1]) == "test value with parameter - 1 [C]")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 60.0)
        XCTAssert(self.downloadCount == 2, "Download handler should be called twice")
    }
}
