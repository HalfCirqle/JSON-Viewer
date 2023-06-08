//
//  JSONTreeView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct JSONTreeView: View {
    @State var column1Size: CGFloat = 300
    @State var column2Size: CGFloat = 300
    @GestureState var dragOffset: CGFloat = 0

    var nodes: [Node]

    let minWidth: CGFloat = 100  // set a minimum width for the column

    var body: some View {
        ScrollView(.horizontal) {
            VStack {
                HStack {
                    HStack {
                        Text ("Key")
                        Spacer()
                    }
                    .padding(.leading, 50)
                    .padding(10)
                    .background(Color.primary.opacity(0.1).cornerRadius(5))
                    .frame(width: max(minWidth, column1Size + dragOffset))
                    ResizingHandle()
                        .gesture(
                            DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                .updating($dragOffset) { value, state, transaction in
                                    state = value.translation.width
                                }
                                .onEnded { value in
                                    let totalDrag = value.translation.width
                                    let newWidth = max(column1Size + totalDrag, minWidth)
                                    column1Size = newWidth
                                }
                        )
                    HStack {
                        Text ("Value")
                        Spacer()
                    }
                    .frame(width: column2Size)
                    .padding(10)
                    .background(Color.primary.opacity(0.1).cornerRadius(5))
                    Spacer()
                }
                .padding(10)
//                .background(Color.primary.opacity(0.1))
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(nodes[0].children!) { node in
                            NodeView(node: node, level: 0, column1Size: Binding(
                                get: { self.column1Size + self.dragOffset },
                                set: { _ in }
                            ))
                        }
                    }.padding()
                }
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
