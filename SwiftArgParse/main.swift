//
//  main.swift
//  SwiftArgParse
//
//  Created by Avihu Turzion on 10/09/2017.
//  Copyright © 2017 Avihu Turzion. All rights reserved.
//

import Foundation

func sparseArgs(arg1: String = "arg1", arg2: String = "arg2", arg3: String = "arg3") {
  print([arg1, arg2, arg3].joined(separator: " "))
}

sparseArgs(arg2: "blah")
