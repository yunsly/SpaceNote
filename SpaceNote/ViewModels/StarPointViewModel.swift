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
    
    // 우주 좌표 변환
    func convertToSpaceCoordinates(screenPos: CGPoint, scale: CGFloat, offset: CGSize) -> CGPoint {
        CGPoint(
            x: (screenPos.x - offset.width) / scale,
            y: (screenPos.y - offset.height) / scale
        )
    }
    
    // 특정 위치에 별 추가하는 함수
    func addStar(at screenPosition: CGPoint, scale: CGFloat, offset: CGSize, title: String, content: String) {
        let spacePosition = convertToSpaceCoordinates(screenPos: screenPosition, scale: scale, offset: offset)

        let newStar = StarPoint(position: spacePosition, title: title, content: content)
        modelContext.insert(newStar)
        try? modelContext.save()
        stars.append(newStar)
    }


    
    
    // 랜덤한 자리에 별 생성
    func addRandomStar(in size: CGSize, scale: CGFloat, offset: CGSize, title: String, content: String) {
        let padding: CGFloat = 50
        let randomX = CGFloat.random(in: padding...(size.width - padding))
        let randomY = CGFloat.random(in: padding...(size.height - padding))
        let screenPosition = CGPoint(x: randomX, y: randomY)

        addStar(at: screenPosition, scale: scale, offset: offset, title: title, content: content)
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
    func findStar(near screenLocation: CGPoint, scale: CGFloat, offset: CGSize, threshold: CGFloat = 30) -> StarPoint? {
        stars.first {
            let screenPos = $0.position.applying(scale: scale, offset: offset)
            return hypot(screenLocation.x - screenPos.x, screenLocation.y - screenPos.y) < threshold
        }
    }
    
    // 별 연결하기
    func connectStars(start: StarPoint, end: StarPoint, constellationID: UUID) {
        let alreadyConnected = connections.contains {
            ($0.fromStarID == start.id && $0.toStarID == end.id) ||
            ($0.fromStarID == end.id && $0.toStarID == start.id)
        }

        guard !alreadyConnected else { return }

        let connection = StarConnection(from: start.id, to: end.id, constellationID: constellationID)
        modelContext.insert(connection)

        // 별도 소속 설정 (중복 방지 로직은 필요 시 추가 가능)
        start.constellationID = constellationID
        end.constellationID = constellationID

        try? modelContext.save()
        connections.append(connection)
    }


}
