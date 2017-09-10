//
//  ArgParse.swift
//  SwiftArgParse
//
//  Created by Avihu Turzion on 10/09/2017.
//  Copyright © 2017 Avihu Turzion. All rights reserved.
//

import Foundation

class ArgParse {
  let appName: String
  
  init(appName: String) {
    self.appName = appName
  }
  
  func parse() -> [String: String] {
    return parse(args: CommandLine.arguments)
  }
  
  func parse(args: [String]) -> [String: String] {
    return [:]
  }
}
