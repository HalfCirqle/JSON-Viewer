//
//  ContentView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var jsonText: String = ""
    @State private var rootNode: Node?
    
    @State private var viewMode: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewMode == 0 {
                    TextEditor(text: $jsonText)
                        .border(Color.gray, width: 0.5)
                        .padding()
                } else {
                    if let root = rootNode {
                        JSONTreeView(nodes: [root])
                    }
                }
            }
            .background(Color.white)
            .navigationTitle("JSON Viewer")
            .navigationSubtitle("Untitled File")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Picker("", selection: $viewMode) {
                        Text("Text")
                            .tag(0)
                        Text("JSON Visualizer")
                            .tag(1)
                    }.pickerStyle(.segmented)
                        .onChange(of: viewMode) { _ in
                            parseJSON()
                        }
                }
            }
        }
    }
    
    func parseJSON() {
        guard let data = jsonText.data(using: .utf8) else {
            print("Invalid JSON text")
            return
        }
        
        do {
            let json = try JSONDecoder().decode([String: JSONValue].self, from: data)
            rootNode = Node(key: "root", value: "", type: .object, children: parse(json: json))
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
    func parse(json: [String: JSONValue], keyPrefix: String = "") -> [Node] {
        var nodes: [Node] = []
        for (key, jsonValue) in json {
            let keyWithPrefix = keyPrefix == "" ? key : keyPrefix + "." + key
            let type: JSONValueType
            switch jsonValue {
            case .string:
                type = .string
                nodes.append(Node(key: key, value: jsonValue.stringValue, type: type, children: nil))
            case .int, .double:
                type = .number
                nodes.append(Node(key: key, value: jsonValue.stringValue, type: type, children: nil))
            case .bool:
                type = .bool
                nodes.append(Node(key: key, value: jsonValue.stringValue, type: type, children: nil))
            case .object(let value):
                type = .object
                nodes.append(Node(key: key, value: "", type: type, children: parse(json: value, keyPrefix: keyWithPrefix + ".")))
            case .array(let array):
                type = .array
                var childNodes: [Node] = []
                for (index, value) in array.enumerated() {
                    let newPrefix = "\(keyWithPrefix)[\(index)]"
                    switch value {
                    case .object(let objectValue):
                        var childNode = Node(key: "[\(index)]", value: value.stringValue, type: .array, children: nil)
                        childNode.children = []
                        let objectNodes = parse(json: objectValue, keyPrefix: newPrefix + ".")
                        for objectNode in objectNodes {
                            childNode.children!.append(Node(key: objectNode.key, value: objectNode.value, type: objectNode.type, children: objectNode.children))
                        }
                        childNodes.append(childNode)
                    default:
                        let childNode = Node(key: newPrefix, value: value.stringValue, type: .array, children: nil)
                        childNodes.append(childNode)
                    }
                }
                nodes.append(Node(key: key, value: "", type: type, children: childNodes))
            case .null:
                type = .null
                nodes.append(Node(key: key, value: jsonValue.stringValue, type: type, children: nil))
            }
        }
        return nodes
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
