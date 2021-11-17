//
//  SetGameApp.swift
//  SetGame
//
//  Created by 60080341 on 2021/11/08.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = FirstSetGame()
    
    var body: some Scene {
        WindowGroup {
            FirstSetGameView(game: game)
        }
    }
}
