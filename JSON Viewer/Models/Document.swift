//
//  Document.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/10/23.
//

import SwiftUI
import UniformTypeIdentifiers

/**
 A `FileDocument` compliant struct representing a document in the application.
 The `Document` struct is responsible for maintaining and serializing the primary data model for the application. This includes a single `Node` object, which represents the root of a tree of `Node` objects.
 - Important: This struct must be initialized with a `Node`.
 It also includes metadata about the document, including its version, creation date, modification date, and comments.
 - Note: The document version is initially `1` and can be incremented as needed.
 The `Document` struct conforms to the `FileDocument` protocol, which means it can be used with SwiftUI's document-based app architecture. It provides methods for reading documents from and writing documents to disk.
 */
struct Document: FileDocument {

    /// The root node of the document.
    var node: Node?

    /// The version of the document. This is initially `1`.
    var version: Int

    /// The date the document was created.
    var createdAt: Date

    /// The date the document was last modified.
    var modifiedAt: Date

    /// Any comments about the document.
    var comments: String

    /**
     Creates a new `Document`.
     - Parameter node: The root node of the document. This defaults to `nil`.
     */
    init(node: Node? = nil) {
        self.node = node
        self.version = 1
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.comments = ""
    }

    /// The readable content types for the document.
    static var readableContentTypes: [UTType] { [.jsonCommentedDocument] }

    /**
     Initializes a new `Document` from a `ReadConfiguration`.
     - Parameter configuration: The `ReadConfiguration` to initialize from.
     - Throws: An error if the document data is corrupt or cannot be read.
     */
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let decoded = try? JSONDecoder().decode(Document.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = decoded
    }

    /**
     Returns a `FileWrapper` that represents the document's current state.
     - Parameter configuration: A `WriteConfiguration` to write with.
     - Throws: An error if the document's contents cannot be encoded.
     - Returns: A `FileWrapper` containing the encoded document.
     */
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}

extension Document: Codable {

    /// An enumeration of the coding keys used to encode and decode a `Document`.
    enum CodingKeys: CodingKey {
        case node, version, createdAt, modifiedAt, comments
    }

    /**
     Initializes a new `Document` from a decoder.
     - Parameter decoder: The `Decoder` to decode data from.
     - Throws: An error if the document cannot be decoded.
     */
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        node = try values.decode(Node.self, forKey: .node)
        version = try values.decode(Int.self, forKey: .version)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        modifiedAt = try values.decode(Date.self, forKey: .modifiedAt)
        comments = try values.decode(String.self, forKey: .comments)
    }

    /**
     Encodes the `Document` to an encoder.
     - Parameter encoder: The `Encoder` to encode data to.
     - Throws: An error if the document cannot be encoded.
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(node, forKey: .node)
        try container.encode(version, forKey: .version)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
        try container.encode(comments, forKey: .comments)
    }
}

extension UTType {
    /// A UTType that identifies the custom document type for this application.
    static var jsonCommentedDocument: UTType {
        UTType(exportedAs: "com.halfcirqle.json-commented")
    }
}
