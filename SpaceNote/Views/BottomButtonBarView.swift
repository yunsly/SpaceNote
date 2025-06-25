//
//  BottomButtonBarView.swift
//  SpaceNote
//
//  Created by Noah on 6/22/25.
//

import SwiftUI

struct BottomButtonBarView: View {
    @ObservedObject var viewModel: StarPointViewModel
    @Binding var selectedTab: Int
    
    @State private var isRemove: Bool = true
    @State private var isExpanded: Bool = false
    @State private var isEdit: Bool = false
    
    @State private var title: String = ""
    @State private var content: String = ""
    @Namespace private var namespace
    @Namespace private var plusButtonNamespace
    
    var body: some View {
        GeometryReader { geometry in
            GlassEffectContainer {
                VStack{
                    Spacer()
                    if isExpanded {
                        
                        TextField(
                            text: $title,
                            prompt: Text("타이틀을 입력하세요")
                        ) {
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .glassEffect(.regular.tint(.white.opacity(0.2)))
                        .glassEffectID("title", in: plusButtonNamespace)
                        
                        TextField(
                            text: $content,
                            prompt: Text("내용을 입력하세요")
                            ) {
                            }
                            .foregroundColor(.white)
                            .frame(height: 300)
                            .font(.system(size: 20))
                            .padding()
                            .glassEffect(.regular.tint(.white.opacity(0.2)), in: .rect(cornerRadius: 30.0))
                            .glassEffectID("content", in: plusButtonNamespace)
                        
                        HStack{
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                    isRemove = true
                                }
                            }) {
                                Text("취소")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .glassEffect(.regular.interactive())
                            .glassEffectID("0", in: namespace)
                            
                            Button(action: {
                                viewModel.addRandomStar(in: geometry.size)
                                withAnimation {
                                    isExpanded.toggle()
                                    isRemove = true
                                }
                            }) {
                                Text("확인")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .glassEffect(.regular.tint(.purple.opacity(0.5)).interactive())
                            .glassEffectID("plusButton", in: namespace)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    HStack {
                        
                        if isEdit {
                            //확인 버튼
                            Button(action: {
                                selectedTab = 0
                                withAnimation {
                                    isEdit = false
                                    isRemove = true
                                }
                            }) {
                                Text("확인")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200.0, height: 60.0)
                            .glassEffect(.regular.interactive())
                            .glassEffectID("plusButton", in: plusButtonNamespace)
                            .glassEffectUnion(id: "0", namespace: namespace)

                        }
                        
                        if isRemove {
                            //리스트 버튼
                            Button(action: {
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                            .frame(width: 60.0, height: 60.0)
                            .glassEffect(.regular.interactive())
                            .glassEffectID("0", in: namespace)
                            //                    .glassEffectUnion(id: "1", namespace: namespace)
                            
                            Spacer()
                            
                            //에딧 버튼
                            Button(action: {
                                selectedTab = 1
                                withAnimation {
                                    isEdit = true
                                    isRemove = false
                                }
                            }) {
                                Image(systemName: "sparkles")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                            .frame(width: 60.0, height: 60.0)
                            //                .buttonStyle(.glass)
                            .glassEffect(.regular.interactive())
                            .glassEffectID("plusButton", in: plusButtonNamespace)
                            .glassEffectUnion(id: "0", namespace: namespace)
                            
                            Spacer()
                            
                            //플러스 버튼
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                    isRemove = false
                                }
                            }) {
                                Image("Plus")
                                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                            .frame(width: 60.0, height: 60.0)
                            .glassEffect(.regular.tint(.purple.opacity(0.5)).interactive())
                            .glassEffectID("1", in: namespace)
//                        .glassEffectID("3", in: namespace)
                            .glassEffectUnion(id: "1", namespace: namespace)
                            
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

