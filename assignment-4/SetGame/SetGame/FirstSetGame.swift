//
//  FirstSetGame.swift
//  SetGame
//
//  Created by 60080341 on 2021/11/08.
//

import SwiftUI

class FirstSetGame: ObservableObject {
    @Published private var model = createSetGame()
    
    private static func createSetGame() -> SetGame {
        SetGame()
    }
        
    var deck: [Card] {
        model.deck
    }
    
    var table: [Card] {
        model.table
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealThreeMoreCard() {
        model.dealThreeMoreCard()
    }
    
    func newGame() {
        model = Self.createSetGame()
    }
}
