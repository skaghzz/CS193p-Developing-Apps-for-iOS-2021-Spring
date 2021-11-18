//
//  SetGame.swift
//  SetGame
//
//  Created by 60080341 on 2021/11/08.
//

// Model

import Foundation
import SwiftUI

struct SetGame {
    private(set) var deck: [Card]
    private(set) var table: [Card]
    private(set) var discardPile: [Card] = []
    
    private struct GameConstants {
        static let numberOfCardOnTable = 12
        static let numberOfMatchCard = 3
        static let numberOfDealCard = 3
    }
        
    private var indexOfchosen: [Int] {
        get { table.indices.filter { table[$0].isChoose } }
    }
        
    private var isMatch: Bool {
        get {
            if indexOfchosen.count == GameConstants.numberOfMatchCard {
                let card1 = table[indexOfchosen[0]]
                let card2 = table[indexOfchosen[1]]
                let card3 = table[indexOfchosen[2]]
                let isSetOfNumberOfShape = (card1.numberOfSymbol == card2.numberOfSymbol && card1.numberOfSymbol == card3.numberOfSymbol) ||
                (card1.numberOfSymbol != card2.numberOfSymbol && card2.numberOfSymbol != card3.numberOfSymbol && card1.numberOfSymbol != card3.numberOfSymbol)
                let isSetOfColor = (card1.color == card2.color && card1.color == card3.color) ||
                (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color)
                let isSetOfSymbol = (card1.symbol == card2.symbol && card1.symbol == card3.symbol) ||
                (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card1.symbol != card3.symbol)
                let isSetOfshading = (card1.shading == card2.shading && card1.shading == card3.shading) ||
                (card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading)
                return isSetOfNumberOfShape && isSetOfColor && isSetOfSymbol && isSetOfshading
            } else {
                return false
            }
        }
    }
    
    init() {
        deck = []
        var id = 0
        for symbol in Card.Symbol.allCases {
            for shading in Card.Shading.allCases {
                for color in Card.Color.allCases {
                    for number in 1...3 {
                        deck.append(Card(numberOfSymbol: number, symbol: symbol, shading: shading, color: color, id: id))
                        id += 1
                    }
                }
            }
        }
        deck.shuffle()

        table = []
        for _ in 0..<GameConstants.numberOfCardOnTable {
            var card = deck.popLast()!
            card.isFaceUp = true
            table.append(card)
        }
    }
    
    mutating func choose(_ card: Card) {
        if indexOfchosen.count == GameConstants.numberOfMatchCard {
            if isMatch {
                //replaceNewCard()
                discard()
            }
            table.indices.forEach {
                table[$0].isChoose = false
                table[$0].isSet = nil
            }
        }
        
        if let chosenIndex = table.firstIndex(where: {$0.id == card.id}) {
            table[chosenIndex].isChoose.toggle()
            if indexOfchosen.count == GameConstants.numberOfMatchCard {
                let isMatch = isMatch
                indexOfchosen.forEach({ i in
                    table[i].isSet = isMatch
                })
            }
        }
    }
    
    private mutating func discard() {
        indexOfchosen.reversed().forEach({ i in
            var card = table.remove(at: i)
            card.isSet = nil
            card.isChoose = false
            discardPile.append(card)
        })
    }
    
    private mutating func replaceNewCard() {
        indexOfchosen.reversed().forEach({ i in
            var card = table.remove(at: i)
            card.isSet = nil
            card.isChoose = false
            discardPile.append(card)
            if !deck.isEmpty {
                var card = deck.popLast()!
                card.isFaceUp = true
                table.insert(card, at: i)
            }
        })
    }
    
    mutating func dealThreeMoreCard() {
        if indexOfchosen.count == GameConstants.numberOfMatchCard {
            if isMatch {
                replaceNewCard()
                return
            }
        }
        for _ in 0..<GameConstants.numberOfDealCard {
            var card = deck.popLast()!
            card.isFaceUp = true
            table.append(card)
        }
    }
}
