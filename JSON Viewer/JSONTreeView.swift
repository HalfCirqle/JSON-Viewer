//
//  JSONTreeView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct JSONTreeView: View {
    var nodes: [Node]

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text ("Key")
                    Spacer()
                }
                .padding(.leading, 50)
                .frame(width: 300)
                Text ("Value")
                Spacer()
            }.padding(10)
                .background(Color.primary.opacity(0.1))
            ScrollView {
                LazyVStack(spacing: 5) {
                    ForEach(nodes[0].children!) { node in
                        NodeView(node: node, level: 0)
                    }
                }.padding()
            }
        }
    }
}


struct JSONTreeView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleNodes = [
            Node(key: "address", value: "", type: .object, children: [
                Node(key: "street", value: "123 Main St", type: .string, children: nil),
                Node(key: "city", value: "Springfield", type: .string, children: nil),
                Node(key: "state", value: "IL", type: .string, children: nil)
            ])
        ]

        JSONTreeView(nodes: exampleNodes)
    }
}
