//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
