//
//  TabBarView 2.swift
//  SpaceNote
//
//  Created by Noah on 6/21/25.
//


//
//  TabBarView.swift
//  SpaceNote
//
//  Created by yunsly on 6/20/25.
//

import SwiftUI

struct TabBarView2: View {
    @Binding var selectedTab: Int
    @Namespace private var tabBarNamespace
    @State private var isToggle: Bool = false
    @State private var isOn: Bool = false
    
    var body: some View {
        ZStack(alignment: selectedTab == 0 ? .leading : .trailing) {
            //            GlassEffectContainer(spacing: 20.0) {
            //                HStack(spacing: 20.0) {
            //                    Image(systemName: "sparkles")
            //                        .frame(width: 60.0, height: 60.0)
            //                        .font(.system(size: 36))
            //                        .glassEffect()
            //                        .glassEffectUnion(id: 0, namespace: tabBarNamespace)
            //                    Image(systemName: "sparkles")
            //                        .frame(width: 60.0, height: 60.0)
            //                        .font(.system(size: 36))
            //                        .glassEffect()
            //                        .glassEffectUnion(id: 0, namespace: tabBarNamespace)
            //                }
            //            }
            Button {
                selectedTab = 0
            } label: {
                GlassEffectContainer(spacing: 20.0){
                    HStack(spacing: 20.0) {
                        Image(systemName: "sparkles")
                            .frame(width: 60.0, height: 60.0)
                            .foregroundColor(selectedTab == 0 ? .black : .white)
                            .font(.system(size: 36))
                            .glassEffect()
                            .glassEffectUnion(id: 0, namespace: tabBarNamespace)
                        Image(systemName: "sparkles")
                            .frame(width: 60.0, height: 60.0)
                            .foregroundColor(selectedTab == 1 ? .black : .white)
                            .font(.system(size: 36))
                            .glassEffect()
                            .glassEffectUnion(id: 0, namespace: tabBarNamespace)
                    }
                }
            }
            
//            VStack {
//                Toggle("알림 설정", isOn: $isOn)
//                .buttonStyle(.glass)
//                .toggleStyle(SwitchToggleStyle(tint: .purple.opacity(0.4)))
//                .padding()
//
//                    }

//            Circle()
//                .glassEffect(.regular.interactive())
//            //                        .fill(Color.white.opacity(0.0))
//                .frame(width: 44, height: 44)
//                .shadow(radius: 3)
//                .offset(x: selectedTab == 0 ? 0 : 0) // alignment와 padding으로 처리
//                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
        }
    }
}

