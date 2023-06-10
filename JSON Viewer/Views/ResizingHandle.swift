//
//  ResizingHandle.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/8/23.
//

import SwiftUI

struct ResizingHandle: View {
    @State private var isHovering = false
    var body: some View {
        Rectangle()
            .opacity(isHovering ? 0.3 : 0.1)
            .animation(.easeInOut, value: isHovering)
            .cornerRadius(5)
            .frame(width: 10, height: 30)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

struct ResizingHandle_Previews: PreviewProvider {
    static var previews: some View {
        ResizingHandle()
            .padding()
    }
}
