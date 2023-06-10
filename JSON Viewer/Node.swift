//
//  Node.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import Foundation

struct Node: Identifiable {
    let id = UUID()
    let key: String
    let value: String
    let type: JSONValueType
    var children: [Node]?
    var comments: String = ""
}
