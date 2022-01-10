//
//  ContentView.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/22.
//

// View

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Theme")
            Text(viewModel.themeModel.name)
            Text("score")
                .font(.largeTitle)
            Text("\(viewModel.gameScore)")
                .font(.title2)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, cardGradient: viewModel.cardGradient)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            //.foregroundColor(viewModel.cardColor)
            .padding(.horizontal)
            Button(action: {
                viewModel.newGame()
            }) {
                Text("New Game")
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let cardGradient: LinearGradient
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill(cardGradient)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill(cardGradient)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
