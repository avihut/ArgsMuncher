//
//  ArgParse.swift
//  SwiftArgParse
//
//  Created by Avihu Turzion on 10/09/2017.
//  Copyright © 2017 Avihu Turzion. All rights reserved.
//

import Foundation

private let kPathSep: Character = "/"

enum ArgumentError: Error {
  case duplicate(original: Argument, duplicate: Argument)
}

enum ParseError: Error {
  case tooManyArguments(remaining: [String])
  case missingArguments(missing: [Argument])
}

struct ArgParser {
  private let appName: String
  private let description: String?
  
  private var arguments: [Argument] = []
  
  init(description: String? = nil) {
    if let commandName = CommandLine.arguments[0].split(separator: kPathSep).last {
      self.init(appName: String(commandName), description: description)
    } else {
      self.init(appName: CommandLine.arguments[0], description: description)
    }
  }
  
  init(appName: String, description: String? = nil) {
    self.appName = appName
    self.description = description
  }
  
  func parse() throws -> [String: [String]] {
    return try parse(args: CommandLine.arguments)
  }
  
  func parse(args commandLineArguments: [String]) throws -> [String: [String]] {
    var attributes: [String: [String]] = [:]
    var arguments = Array(self.arguments)
    var commandLineArguments = commandLineArguments
    
    var i = 1
    while i < commandLineArguments.count {
      guard !arguments.isEmpty else {
        throw ParseError.tooManyArguments(remaining: Array(commandLineArguments[i..<commandLineArguments.count]))
      }
      
      let currentArgument = arguments.remove(at: 0)
      
      if currentArgument.multipleValues {
        attributes[currentArgument.name] = Array(commandLineArguments[i..<commandLineArguments.count])
        i = commandLineArguments.count
        continue
      } else {
        attributes[currentArgument.name] = [commandLineArguments[i]]
      }
      
      i += 1
    }
    
    return attributes
  }
  
  mutating func add(_ argument: Argument) throws {
    guard arguments.index(of: argument) == nil else {
      let original = arguments[arguments.index(of: argument)!]
      throw ArgumentError.duplicate(original: original, duplicate: argument)
    }
    arguments.append(argument)
  }
  
  var usage: String {
    var usageText = "\(appName)"
    
    for argument in arguments {
      usageText += " \(argument.displayName)"
    }
    
    if let description = description {
      usageText += "\n\n\(description)"
    }
    
    return "\(usageText)\n"
  }
}

struct Argument {
  let name: String
  let displayName: String
  let multipleValues: Bool
  
  init(name: String, displayName: String, multipleValues: Bool = false) {
    self.name = name
    self.multipleValues = multipleValues
    self.displayName = displayName.uppercased()
  }
}

extension Argument: Hashable {
  var hashValue: Int {
    return name.hashValue
  }
  
  static func ==(lhs: Argument, rhs: Argument) -> Bool {
    return lhs.name == rhs.name
  }
}
