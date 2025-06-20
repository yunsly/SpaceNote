//
//  TabBarView.swift
//  SpaceNote
//
//  Created by yunsly on 6/20/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // 배경 + 이동 원
            ZStack(alignment: selectedTab == 0 ? .leading : .trailing) {
                Capsule()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 50)

                // 선택된 배경 원
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
                    .padding(3)
                    .shadow(radius: 3)
                    .offset(x: selectedTab == 0 ? 0 : 0) // alignment와 padding으로 처리
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            }
            .overlay(
                HStack {
                    Button {
                        selectedTab = 0
                    } label: {
                        Image(systemName: "sparkles")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selectedTab == 0 ? .black : .white)
                    }

                    Button {
                        selectedTab = 1
                    } label: {
                        Image(systemName: "sparkles")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selectedTab == 1 ? .black : .white)
                    }
                }
                .frame(height: 50)
            )
            .frame(width: 120)
            .padding()
        }
    }
}

