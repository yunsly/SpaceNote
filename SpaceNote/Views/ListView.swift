//
//  ListView.swift
//  SpaceNote
//
//  Created by Noah on 6/27/25.
//

import SwiftUI

struct ListView: View {
    @State private var animateItems = false
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<5) { index in
                    Text("Title \(index + 1)")
                        .frame(width: 80, height: 80)
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 30.0))
                        .offset(x: index < 4 && !animateItems ? -(CGFloat(index) * (80 + 16)) : 0)
                        .opacity(index < 4 && !animateItems ? 0 : 1)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.05 * Double(index)), value: animateItems)
                        .onTapGesture {
                            guard !isAnimating else { return }
                            guard !animateItems else { return }
                            isAnimating = true
                            withAnimation {
                                animateItems = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                isAnimating = false
                            }
                        }
                        .disabled(isAnimating)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation { 
                animateItems = true
            }
        }
    }
}

#Preview {
    ListView()
}
