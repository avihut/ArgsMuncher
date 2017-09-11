//
//  ArgParseTests.swift
//  ArgParseTests
//
//  Created by Avihu Turzion on 10/09/2017.
//  Copyright © 2017 Avihu Turzion. All rights reserved.
//

import XCTest

let testAppName = "test"

final class ArgParseUsageTests: XCTestCase {
  var parser: ArgParser!
  
  override func setUp() {
    parser = ArgParser(appName: testAppName)
  }
  
  func testReturnsEmptyAttributeListGivenNoArguments() {
    XCTAssertTrue(try! parser.parse(args: [testAppName]).isEmpty)
  }
  
  func testConstructsUsageWithoutDescription() {
    XCTAssertEqual(parser.usage, "\(testAppName)\n")
  }
  
  func testIsolatesAppNameFromPath() {
    CommandLine.arguments[0] = "directory/\(testAppName)"
    parser = ArgParser()
    XCTAssertEqual(parser.usage, "\(testAppName)\n")
  }
}

final class ArgParseTests: XCTestCase {
  var parser: ArgParser!
  
  override func setUp() {
    parser = ArgParser(appName: testAppName)
  }
  
  func testConstructsUsageWithDescription() {
    let appDescription = "Does some amazing shit!"
    parser = ArgParser(appName: testAppName, description: appDescription)
    XCTAssertEqual(parser.usage, "\(testAppName)\n\n\(appDescription)\n")
  }
  
  func testErrorsWhenAddingMoreThanOneArgumentWithTheSameName() {
    let argName = "arg"
    try? XCTAssertNoThrow(parser.add(Argument(name: argName, displayName: argName)))
    try! XCTAssertThrowsError(parser.add(Argument(name: argName, displayName: argName)))
  }
  
  func testParsesSingleArgument() {
    let argName = "arg"
    let argValue = "val"
    
    XCTAssertNoThrow(try parser.add(Argument(name: argName, displayName: argName)))
    let attributes = try! parser.parse(args: [testAppName, argValue])
    XCTAssertEqual(attributes[argName]!, [argValue])
  }
  
  func testCanParseTheSameArgumentsTwice() {
    let argName = "arg"
    let argValue = "val"
    
    XCTAssertNoThrow(try parser.add(Argument(name: argName, displayName: argName)))
    let attributes1 = try! parser.parse(args: [testAppName, argValue])
    XCTAssertEqual(attributes1[argName]!, [argValue])
    
    let attributes2 = try! parser.parse(args: [testAppName, argValue])
    XCTAssertEqual(attributes1.count, attributes2.count)
    for (attribute, _) in attributes1 {
      XCTAssertEqual(attributes1[attribute]!, attributes2[attribute]!)
    }
  }
  
  func testParsesMultipleArguments() {
    let argNames = ["arg1", "arg2", "arg3"]
    let argValues = ["val1", "val2", "val3"]
    
    for argName in argNames {
      XCTAssertNoThrow(try parser.add(Argument(name: argName, displayName: argName)))
    }
    
    let attributes = try! parser.parse(args: commandLineArgumentList(for: argValues))
    
    for i in 0..<argNames.count {
      XCTAssertEqual(attributes[argNames[i]]!, [argValues[i]])
    }
  }
  
  func testParsesMultipleCommandLineArgumentsForTheSameAttribute() {
    let argName = "files"
    let fileArgs = ["file1", "file2", "file3"]
    
    XCTAssertNoThrow(try parser.add(Argument(name: argName, displayName: argName, multipleValues: true)))
    let attributes = try! parser.parse(args: commandLineArgumentList(for: fileArgs))
    XCTAssertEqual(attributes[argName]!, fileArgs)
  }
  
  private func commandLineArgumentList(for args: [String]) -> [String] {
    var commandLineArguments = Array(args)
    commandLineArguments.insert(testAppName, at: 0)
    return commandLineArguments
  }
}

