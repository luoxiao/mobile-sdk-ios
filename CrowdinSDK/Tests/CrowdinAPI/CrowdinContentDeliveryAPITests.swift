//
//  CrowdinContentDeliveryAPITests.swift
//  CrowdinSDK-Unit-CrowdinAPI_Tests
//
//  Created by Serhii Londar on 29.10.2019.
//

import XCTest
@testable import CrowdinSDK

class CrowdinContentDeliveryAPITests: XCTestCase {
    var session = URLSessionMock()
    var crowdinContentDeliveryAPI: CrowdinContentDeliveryAPI!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        crowdinContentDeliveryAPI = nil
    }

    func testCrowdinContentDeliveryAPIGetStrings() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        key = value;
        """
        session.data = fileString.data(using: .utf8)
        
        var result: [String: String]? = nil
        crowdinContentDeliveryAPI.getStrings(filePath: "filePath") { (strings, error) in
            result = strings
        }
        
        XCTAssertNotNil(result)
        XCTAssert(result?.count == 1)
        XCTAssert(result?.contains(where: { $0 == "key" && $1 == "value" }) ?? false)
    }
    
    func testCrowdinContentDeliveryAPIGetStringsSync() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        key = value;
        """
        session.data = fileString.data(using: .utf8)
        
        let result: [String: String]? = crowdinContentDeliveryAPI.getStringsSync(filePath: "filePath").strings
        
        XCTAssertNotNil(result)
        XCTAssert(result!.count == 1)
        XCTAssert(result!.contains(where: { $0 == "key" && $1 == "value" }))
    }
    
    
    func testCrowdinContentDeliveryAPIGetStringsMappingSync() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        key = 123;
        """
        session.data = fileString.data(using: .utf8)
        
        let result: [String: String]? = crowdinContentDeliveryAPI.getStringsMappingSync(filePath: "filePath").strings
        
        XCTAssertNotNil(result)
        XCTAssert(result!.count == 1)
        XCTAssert(result!.contains(where: { $0 == "key" && $1 == "123" }))
    }

    
    func testCrowdinContentDeliveryAPIGetPlurals() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>johns_pineapples_count</key>
            <dict>
                <key>NSStringLocalizedFormatKey</key>
                <string>%#@v1_pineapples_count@</string>
                <key>v1_pineapples_count</key>
                <dict>
                    <key>NSStringFormatSpecTypeKey</key>
                    <string>NSStringPluralRuleType</string>
                    <key>NSStringFormatValueTypeKey</key>
                    <string>u</string>
                    <key>zero</key>
                    <string>John has no pineapples</string>
                    <key>one</key>
                    <string>John has 1 pineapple</string>
                    <key>other</key>
                    <string>John has %u pineapples</string>
                </dict>
            </dict>
        </dict>
        </plist>
        """
        session.data = fileString.data(using: .utf8)
        
        var result: [AnyHashable: Any]? = nil
        crowdinContentDeliveryAPI.getPlurals(filePath: "filePath") { (response, error) in
            result = response
        }
        
        XCTAssertNotNil(result)
        XCTAssert(result!.isEmpty == false)
        XCTAssert(result!["johns_pineapples_count"] != nil)
    }
    
    
    func testCrowdinContentDeliveryAPIGetPluralsSync() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>johns_pineapples_count</key>
            <dict>
                <key>NSStringLocalizedFormatKey</key>
                <string>%#@v1_pineapples_count@</string>
                <key>v1_pineapples_count</key>
                <dict>
                    <key>NSStringFormatSpecTypeKey</key>
                    <string>NSStringPluralRuleType</string>
                    <key>NSStringFormatValueTypeKey</key>
                    <string>u</string>
                    <key>zero</key>
                    <string>John has no pineapples</string>
                    <key>one</key>
                    <string>John has 1 pineapple</string>
                    <key>other</key>
                    <string>John has %u pineapples</string>
                </dict>
            </dict>
        </dict>
        </plist>
        """
        session.data = fileString.data(using: .utf8)
        
        let result: [AnyHashable: Any]? = crowdinContentDeliveryAPI.getPluralsSync(filePath: "filePath").plurals
        
        XCTAssertNotNil(result)
        XCTAssert(result!.isEmpty == false)
        XCTAssert(result!["johns_pineapples_count"] != nil)
    }
    
    func testCrowdinContentDeliveryAPIGetPluralsMappingSync() {
        crowdinContentDeliveryAPI = CrowdinContentDeliveryAPI(hash: "hash", enterprise: true, session: session)
        let fileString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>johns_pineapples_count</key>
            <dict>
                <key>NSStringLocalizedFormatKey</key>
                <string>%#@v1_pineapples_count@</string>
                <key>v1_pineapples_count</key>
                <dict>
                    <key>NSStringFormatSpecTypeKey</key>
                    <string>NSStringPluralRuleType</string>
                    <key>NSStringFormatValueTypeKey</key>
                    <string>u</string>
                    <key>zero</key>
                    <string>111111</string>
                    <key>one</key>
                    <string>222222</string>
                    <key>other</key>
                    <string>333333</string>
                </dict>
            </dict>
        </dict>
        </plist>
        """
        session.data = fileString.data(using: .utf8)
        
        let result: [AnyHashable: Any]? = crowdinContentDeliveryAPI.getPluralsMappingSync(filePath: "filePath").plurals
        
        XCTAssertNotNil(result)
        XCTAssert(result!.isEmpty == false)
        XCTAssert(result!["johns_pineapples_count"] != nil)
    }
}
