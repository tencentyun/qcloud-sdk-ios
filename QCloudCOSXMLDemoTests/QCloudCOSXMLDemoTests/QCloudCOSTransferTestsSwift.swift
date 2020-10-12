//
//  QCloudCOSTransferTestsSwift.swift
//  QCloudCOSXMLDemoTests
//
//  Created by karisli(李雪) on 2018/8/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

import XCTest
class QCloudCOSTransferTestsSwift: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUploadObject() {
        let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        put.object = "中文名小文件"
        put.bucket = "karis-bucketcanbedelete804"
        let str = "111"
        
        
        put.body = str.data(using: String.Encoding.utf8) as AnyObject
        // 声明带参数和有返回值的闭包在函数名中
        let exp  = XCTestExpectation.init(description: "test")
        
            
        put.setFinish { (result, error) in
            exp.fulfill()
            
        }
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
        self.wait(for: [exp], timeout: 18000)
        
    }
    
}
