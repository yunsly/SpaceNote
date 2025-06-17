//
//  NavigationManager.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to destination: Route) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
