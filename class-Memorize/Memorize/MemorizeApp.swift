//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
