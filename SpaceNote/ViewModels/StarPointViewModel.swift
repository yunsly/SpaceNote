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
    @Published var connections: [StarConnection] = []
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchStars()
        fetchConnections()
    }
    
    // 별 목록 조회
    func fetchStars() {
        let descriptor = FetchDescriptor<StarPoint>()
        if let result = try? modelContext.fetch(descriptor) {
            stars = result
        }
    }
    
    // 별자리 연결 리스트 조회
    func fetchConnections() {
        let descriptor = FetchDescriptor<StarConnection>()
        if let result = try? modelContext.fetch(descriptor) {
            connections = result
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
    
    // 터치가 닿은 영역의 주변 별 찾기
    func findStar(near position: CGPoint, threshold: CGFloat = 24) -> StarPoint? {
        stars.first {
            hypot($0.position.x - position.x, $0.position.y - position.y) < threshold
        }
    }
    
    // 별 연결하기
    func connectStars(start: StarPoint, end: StarPoint) {
        // 중복 연결 방지
        let alreadyConnected = connections.contains {
            ($0.fromStarID == start.id && $0.toStarID == end.id) ||
            ($0.fromStarID == end.id && $0.toStarID == start.id)
        }

        guard !alreadyConnected else { return }

        let connection = StarConnection(from: start.id, to: end.id)
        modelContext.insert(connection)
        try? modelContext.save()
        connections.append(connection)
    }

}
