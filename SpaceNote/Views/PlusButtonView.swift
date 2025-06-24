//
//  PlusButtonView.swift
//  SpaceNote
//
//  Created by Noah on 6/21/25.
//

import SwiftUI

struct PlusButtonView: View {
    @State private var isExpanded: Bool = false
    @State private var isRemove: Bool = true
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer(spacing: 20.0) {
            VStack(alignment: .trailing, spacing: 20.0) {
                if isExpanded {
                    VStack(spacing: 20.0){
                        Text("Hello, World!")
                            .font(.system(size: 20))
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                                isRemove = true
                            }
                        }) {
                            Text("확인")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .glassEffect(.regular.interactive())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(24)
                    .font(.system(size: 36))
                    .glassEffect(.regular, in: .rect(cornerRadius: 30.0))
                    .glassEffectID("0", in: namespace)
                    .glassEffectUnion(id: "0", namespace: namespace)
                }
                //                VStack{
                //                    Image("Plus")
                //                }
                //                .frame(width: 60.0, height: 60.0)
                //                .glassEffect(.regular.interactive())
                //                .glassEffectID("1", in: namespace)
                //                .glassEffectUnion(id: "1", namespace: namespace)
                //                .onTapGesture {withAnimation {
                //                    isExpanded.toggle()
                //                }
                //                }
                if isRemove {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                            isRemove = false
                        }
                    }) {
                        Image("Plus")
                    }
                    .frame(width: 60.0, height: 60.0)
    //                .buttonStyle(.glass)
                    .glassEffect(.regular.interactive())
                    .glassEffectID("1", in: namespace)
                    .glassEffectUnion(id: "1", namespace: namespace)
                }
            }
        }
    }
}
