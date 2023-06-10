//
//  JSON_ViewerApp.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

@main
struct JSON_ViewerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Document()) { file in
            ContentView()
        }
    }
}
