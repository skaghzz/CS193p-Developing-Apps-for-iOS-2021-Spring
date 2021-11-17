//
//  Card.swift
//  SetGame
//
//  Created by 60080341 on 2021/11/08.
//

import Foundation

struct Card: Identifiable {
    var isFaceUp = false
    var isChoose = false
    var isSet: Bool?
    var numberOfSymbol: Int
    var symbol: Symbol
    var shading: Shading
    var color: Color
    var id: Int
    
    enum Symbol: CaseIterable {
        case diamond
        case rectangle
        case oval
    }
    
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case purple
    }
}
