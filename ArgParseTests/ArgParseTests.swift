//
//  ArgParseTests.swift
//  ArgParseTests
//
//  Created by Avihu Turzion on 10/09/2017.
//  Copyright © 2017 Avihu Turzion. All rights reserved.
//

import XCTest

let testAppName = "test"

class ArgParseTests: XCTestCase {
  var parser: ArgParse!
  
  override func setUp() {
    parser = ArgParse(appName: testAppName)
  }
  
  func testReturnsEmptyAttributeListGivenNoArguments() {
    XCTAssertTrue(parser.parse(args: [testAppName]).isEmpty)
  }
}

