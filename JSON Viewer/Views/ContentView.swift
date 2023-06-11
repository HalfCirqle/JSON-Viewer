//
//  ContentView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var document: Document
    @Binding var viewMode: Int
    @State private var jsonText: String = ""
    @State private var jsonViewMode: ViewMode = .spacious
    @State private var showInvalidJSONAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewMode == 0 {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $jsonText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                        if jsonText.isEmpty {
                            HStack(alignment: .bottom) {
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                Text("Dump your JSON in the text editor to get started")
                                Spacer()
                            }.padding(.top, 50)
                                .padding(.leading)
                                .foregroundColor(.secondary)
                        }
                    }.toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                parseJSON()
                            } label: {
                                Text("Visualize")
                            }.disabled(jsonText.isEmpty)
                        }
                        if document.node != nil {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    viewMode = 1
                                } label: {
                                    Text("Cancel")
                                }
                            }
                        }
                    }
                    .alert("The JSON is not valid", isPresented: $showInvalidJSONAlert) {
                        Button("Okay") {
                            showInvalidJSONAlert.toggle()
                        }
                    }
                } else {
                    if let root = document.node {
                        JSONTreeView(viewMode: $jsonViewMode, nodes: [root])
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    Picker("", selection: $jsonViewMode) {
                                        Text(ViewMode.spacious.description)
                                            .tag(ViewMode.spacious)
                                        Text(ViewMode.compact.description)
                                            .tag(ViewMode.compact)
                                    }.pickerStyle(.segmented)
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        NotificationCenter.default.post(name: .closeAll, object: nil)
                                    } label: {
                                        Text("Close All")
                                    }.disabled(jsonText.isEmpty)
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        NotificationCenter.default.post(name: .expandAll, object: nil)
                                    } label: {
                                        Text("Expand All")
                                    }.disabled(jsonText.isEmpty)
                                }
                            }
                    }
                }
            }
            .background(colorScheme == .light ? .white : Color(nsColor: NSColor.windowBackgroundColor))
            .onAppear {
                if document.node != nil {
                    viewMode = 1
                }
            }
        }
    }
    
    func parseJSON() {
        guard let data = jsonText.data(using: .utf8) else {
            print("Invalid JSON text")
            showInvalidJSONAlert.toggle()
            return
        }
        
        do {
            let json = try JSONDecoder().decode([String: JSONValue].self, from: data)
            document.node = Node(key: "root", value: "", type: .object, children: parse(json: json))
            
            viewMode = 1
        } catch {
            print("Failed to parse JSON: \(error)")
            showInvalidJSONAlert.toggle()
        }
    }
    func parse(json: [String: JSONValue], keyPrefix: String = "") -> [Node] {
        var nodes: [Node] = []
        
        let sortedKeys = json.keys.sorted { key1, key2 in
            let value1 = json[key1]!
            let value2 = json[key2]!
            
            // Sort by type: regular values come first, then arrays, then objects
            let order1 = order(for: value1)
            let order2 = order(for: value2)
            if order1 != order2 {
                return order1 < order2
            }
            
            // If types are equal, sort alphabetically by key
            return key1 < key2
        }
        for key in sortedKeys {
            let jsonValue = json[key]!
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
    // Helper function to determine sort order for JSON values
    func order(for value: JSONValue) -> Int {
        switch value {
        case .string, .int, .double, .bool, .null:
            return 0 // Regular values come first
        case .array:
            return 1 // Then arrays
        case .object:
            return 2 // Then objects
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(Document()), viewMode: .constant(1))
    }
}
