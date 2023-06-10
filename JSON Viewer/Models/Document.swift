//
//  Document.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/10/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct Document: FileDocument {
    var node: Node
    var version: Int
    var createdAt: Date
    var modifiedAt: Date
    var comments: String

    init(node: Node) {
        self.node = node
        self.version = 1
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.comments = ""
    }

    // define readable content types for your document
    static var readableContentTypes: [UTType] { [.json] }

    // initialize your document with a file
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let decoded = try? JSONDecoder().decode(Document.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = decoded
    }

    // serialize your document to data to save it
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}

extension Document: Codable {
    enum CodingKeys: CodingKey {
        case node, version, createdAt, modifiedAt, comments
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        node = try values.decode(Node.self, forKey: .node)
        version = try values.decode(Int.self, forKey: .version)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        modifiedAt = try values.decode(Date.self, forKey: .modifiedAt)
        comments = try values.decode(String.self, forKey: .comments)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(node, forKey: .node)
        try container.encode(version, forKey: .version)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
        try container.encode(comments, forKey: .comments)
    }
}
