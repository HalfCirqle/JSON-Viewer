//
//  JSONTreeView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct JSONTreeView: View {
    @State var column1Percentage: CGFloat = 0.33
    @State var column2Percentage: CGFloat = 0.33
    @GestureState var column1DragOffset: CGFloat = 0
    @GestureState var column2DragOffset: CGFloat = 0
    @State var forceOpenAll: Bool = false
    @State var showComments: Bool = false
    
    @Binding var viewMode: ViewMode

    var nodes: [Node]

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let minWidth: CGFloat = 200
            let maxWidth:CGFloat = totalWidth - minWidth

            let column1Size = max(minWidth, min(maxWidth, totalWidth * column1Percentage + column1DragOffset))
            let column2Size = max(minWidth, min(maxWidth, totalWidth * column2Percentage + column2DragOffset))

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
                                .updating($column1DragOffset) { value, state, transaction in
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
                    .padding(10)
                    .background(Color.primary.opacity(0.1).cornerRadius(5))
                    .frame(width: showComments ? column2Size : nil)
                    if showComments {
                        ResizingHandle()
                            .gesture(
                                DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                    .updating($column2DragOffset) { value, state, transaction in
                                        state = value.translation.width
                                    }
                                    .onEnded { value in
                                        let totalDrag = value.translation.width
                                        let newWidth = max(minWidth, min(maxWidth, totalWidth * column2Percentage + totalDrag))
                                        column2Percentage = newWidth / totalWidth
                                    }
                            )
                    }
                    Button {
                        withAnimation {
                            showComments.toggle()
                        }
                    } label: {
                        HStack {
                            if !showComments {
                                Image(systemName: "plus.bubble")
                            } else {
                                Text ("Comments")
                                Spacer()
                            }
                        }
                        .padding(10)
                        .background(Color.primary.opacity(0.1).cornerRadius(5))
                    }.buttonStyle(.plain)
                }
                .padding(10)
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(nodes[0].children!) { node in
                            NodeView(node: node, level: 0, expanded: forceOpenAll, column1Size: Binding(
                                get: { column1Size },
                                set: { _ in }
                            ), column2Size: Binding(
                                get: { column2Size },
                                set: { _ in }
                            ), forceOpenAll: $forceOpenAll, viewMode: $viewMode, showComments: $showComments)
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

        JSONTreeView(viewMode: .constant(.spacious), nodes: exampleNodes)
    }
}
