//
//  JSON_ViewerApp.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

@main
struct JSON_ViewerApp: App {
    @State private var viewMode: Int = 0
    
    var body: some Scene {
        DocumentGroup(newDocument: Document()) { file in
            ContentView(document: file.$document, viewMode: $viewMode)
        }.commands {
            CommandGroup(after: .importExport) {
                Button {
                    viewMode = 0
                } label: {
                    Text("Import JSON File")
                }
            }
        }
    }
}
