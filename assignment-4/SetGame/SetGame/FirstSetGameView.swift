//
//  ContentView.swift
//  SetGame
//
//  Created by 60080341 on 2021/11/08.
//

import SwiftUI

struct FirstSetGameView: View {
    @ObservedObject var game: FirstSetGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    newGame
                }
                .padding(.horizontal)
            }
            HStack {
                deckBody
                Spacer()
                dicardPileBody
            }
        }
        .padding()
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.table, aspectRatio: 2/3, content: { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .padding(4)
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        })
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation {
                game.newGame()
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        //.foregroundColor(CardConstants.color)
        .onTapGesture {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.dealThreeMoreCard()
            }
        }
    }
    
    var dicardPileBody: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        //.foregroundColor(CardConstants.color)
    }
    
    private struct CardConstants {
        static let color = Color.black
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 5
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = FirstSetGame()
        FirstSetGameView(game: game)
    }
}
