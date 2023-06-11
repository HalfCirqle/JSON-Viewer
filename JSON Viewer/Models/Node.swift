//
//  Node.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import Foundation

struct Node: Identifiable, Codable {
    let id: UUID = UUID()
    let key: String
    let value: String
    let type: JSONValueType
    var children: [Node]?
    var comments: String = ""

    // Custom CodingKeys to handle `Identifiable`
    enum CodingKeys: CodingKey {
        case id, key, value, type, children, comments
    }
}
