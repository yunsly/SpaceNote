//
//  StarPointViewModel.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import Foundation
import SwiftData

@MainActor
class StarPointViewModel: ObservableObject {
    @Published var stars: [StarPoint] = []
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchStars()
    }
    
    // 별 목록 조회
    func fetchStars() {
        let descriptor = FetchDescriptor<StarPoint>()
        if let result = try? modelContext.fetch(descriptor) {
            stars = result
        }
    }
    
    // 랜덤한 자리에 별 생성
    func addRandomStar(in size: CGSize) {
        let padding: CGFloat = 50
        let randomX = CGFloat.random(in: padding...(size.width - padding))
        let randomY = CGFloat.random(in: padding...(size.height - padding))
        
        let newStar = StarPoint(position: CGPoint(x: randomX, y: randomY))
        modelContext.insert(newStar)
        try? modelContext.save()
        stars.append(newStar)
    }
    
    // 별 이동 시 위치 업데이트
    func updatePosition(for star: StarPoint, to newPosition: CGPoint) {
        star.position = newPosition
        try? modelContext.save()
    }
    
    // MARK: 디버깅용 - 별 전체 삭제
    func deleteAllStars() {
        for star in stars {
            modelContext.delete(star)
        }
        try? modelContext.save()
        stars.removeAll()
    }
}
