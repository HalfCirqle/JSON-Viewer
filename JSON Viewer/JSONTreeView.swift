//
//  JSONTreeView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct JSONTreeView: View {
    @State var column1Percentage: CGFloat = 0.5
    @GestureState var dragOffset: CGFloat = 0
    @State var forceOpenAll: Bool = false

    var nodes: [Node]

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let minWidth: CGFloat = 200
            let maxWidth:CGFloat = totalWidth - minWidth
            let column1Size = max(minWidth, min(maxWidth, totalWidth * column1Percentage + dragOffset))

            VStack {
                HStack {
                    HStack {
                        Text ("Key")
                        Spacer()
                    }
                    .padding(.leading, 50)
                    .padding(10)
                    .background(Color.primary.opacity(0.1).cornerRadius(5))
                    .frame(width: column1Size)
                    ResizingHandle()
                        .gesture(
                            DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                .updating($dragOffset) { value, state, transaction in
                                    state = value.translation.width
                                }
                                .onEnded { value in
                                    let totalDrag = value.translation.width
                                    let newWidth = max(minWidth, min(maxWidth, totalWidth * column1Percentage + totalDrag))
                                    column1Percentage = newWidth / totalWidth
                                }
                        )
                    HStack {
                        Text ("Value")
                        Spacer()
                    }
//                        .frame(width: max(maxWidth, totalWidth - column1Size - dragOffset))
                    .padding(10)
                    .background(Color.primary.opacity(0.1).cornerRadius(5))
                    Spacer()
                }
                .padding(10)
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(nodes[0].children!) { node in
                            NodeView(node: node, level: 0, expanded: forceOpenAll, column1Size: Binding(
                                get: { column1Size },
                                set: { _ in }
                            ), forceOpenAll: $forceOpenAll)
                        }
                    }.padding()
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: .expandAll)) { _ in
            withAnimation {
                forceOpenAll = true
            }
        }.onReceive(NotificationCenter.default.publisher(for: .closeAll)) { _ in
            withAnimation {
                forceOpenAll = false
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
