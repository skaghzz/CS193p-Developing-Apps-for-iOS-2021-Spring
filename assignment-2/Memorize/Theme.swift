//
//  Theme.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/27.
//

import Foundation

struct Theme {
    private(set) var name: String
    private(set) var emojis: Set<String>
    private(set) var numberOfCardsToShow: Int?
    private(set) var color: String
    
    static let themes = [
        Theme(name: "Vehicle",
              emojis: ["🚲", "🚂","🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"],
              numberOfCardsToShow: 5,
              color: "red"),
        Theme(name: "Cats",
             emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"],
             color: "yellow"),
        Theme(name: "Food",
              emojis: ["🍏", "🍋", "🍓", "🍈", "🍒", "🫐", "🥝", "🍅", "🥦", "🥑", "🥒", "🥕", "🌽"],
              color: "green")
    ]
}
