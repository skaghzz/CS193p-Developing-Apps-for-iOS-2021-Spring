//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/25.
//

// View Model

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGameModel: MemoryGame<String>
    private(set) var themeModel: Theme
    
    init(theme: Theme? = nil) {
        self.themeModel = theme ?? Theme.themes.randomElement()!
        memoryGameModel = EmojiMemoryGame.createMemoryGame(with: self.themeModel)
    }
    
    static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        var numberOfPairsOfCards: Int
        if let numberOfCardsToShow = theme.numberOfCardsToShow {
            if numberOfCardsToShow > theme.emojis.count {
                numberOfPairsOfCards = theme.emojis.count
            } else {
                numberOfPairsOfCards = numberOfCardsToShow
            }
        } else {
            numberOfPairsOfCards = theme.emojis.count
        }
        let shuffledEmojis = theme.emojis.shuffled()
        return MemoryGame<String>.init(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            return shuffledEmojis[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        memoryGameModel.cards
    }
    
    var gameScore: Int {
        memoryGameModel.score
    }
    
    var cardColor: Color {
        switch themeModel.color.lowercased() {
        case "red":
            return .red
        case "green":
            return .green
        case "yellow":
            return .yellow
        default:
            return .orange
        }
    }
    
    var cardGradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [cardColor, cardColor.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        memoryGameModel.choose(card)
    }
    
    func newGame() {
        self.themeModel = Theme.themes.randomElement()!
        memoryGameModel = EmojiMemoryGame.createMemoryGame(with: self.themeModel)
    }
}
