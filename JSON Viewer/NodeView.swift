//
//  NodeView.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI

struct NodeView: View {
    var node: Node
    var level: Int
    @State var expanded = false
    @Binding var column1Size: CGFloat
    
    @Binding var forceOpenAll: Bool

    var body: some View {
        Group {
            if let children = node.children {
                Divider()
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.right")
                            .rotationEffect(expanded ? .degrees(90) : .zero)
                            .animation(.easeInOut, value: expanded)
                            .onTapGesture {
                                withAnimation {
                                    expanded.toggle()
                                }
                            }
                            .frame(width: 15)
                        
                        Image(systemName: node.type.iconName)
                            .foregroundColor(.secondary)
                        Text("\(node.key)")
                        Spacer()
                    }.padding(.leading, 35 * CGFloat(level))
                        .frame(width: column1Size)
                    Spacer()
                }
                if expanded {
                    Group {
                        ForEach(children) { childNode in
                            NodeView(node: childNode, level: level + 1, expanded: forceOpenAll ? true : false, column1Size: $column1Size, forceOpenAll: $forceOpenAll)
                        }
                    }
                }
            } else {
                Divider()
                HStack(spacing: 0.0) {
                    HStack(spacing: 10) {
                        Spacer()
                            .frame(width: 15)
                        Image(systemName: node.type.iconName)
                            .foregroundColor(.secondary)
                        Text("\(node.key)")
                            .foregroundColor(.red)
                            .opacity(0.75)
                        Text(":")
                        Spacer()
                    }.padding(.leading, 35 * CGFloat(level))
                        .frame(width: column1Size)
                    Text("\(node.value)")
                        .foregroundColor(node.type.color)
                        .bold(node.type.bold)
                        .padding(.leading, 15)
                    Spacer()
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: .expandAll)) { _ in
            withAnimation {
                expanded = true
            }
        }.onReceive(NotificationCenter.default.publisher(for: .closeAll)) { _ in
            withAnimation {
                expanded = false
            }
        }
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NodeView(node: Node(key: "name", value: "John", type: .string, children: nil), level: 0, column1Size: .constant(300), forceOpenAll: .constant(true))
            NodeView(node: Node(key: "address", value: "", type: .object, children: [
                Node(key: "street", value: "123 Main St", type: .string, children: nil),
                Node(key: "city", value: "Springfield", type: .string, children: nil),
                Node(key: "state", value: "IL", type: .string, children: nil)
            ]), level: 0, column1Size: .constant(300), forceOpenAll: .constant(true))
        }
        .previewLayout(.sizeThatFits)
    }
}
