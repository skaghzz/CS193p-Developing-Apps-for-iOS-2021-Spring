//
//  ContentView.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var emojis = ["🚲", "🚂","🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️",  "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"].shuffled()
    @State var emojiCount = 10
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
            Spacer()
            HStack(alignment: .bottom) {
                buttonVehicle
                Spacer()
                buttonFace
                Spacer()
                buttonFood
            }
            .font(.subheadline)
            .padding(.horizontal)

        }
        .padding(.horizontal)
    }
    
    let vehicles = ["🚲", "🚂","🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️",  "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"]
    var buttonVehicle: some View {
        Button {
            emojis = vehicles.shuffled()
            emojiCount = vehicles.count
        } label: {
            VStack {
                Image(systemName: "car")
                    .font(.largeTitle)
                Text("car")
            }
        }
    }
    
    let faces = ["😀", "😃", "😆", "😅", "😂", "🤣", "🥲", "☺️", "😊", "😇", "😎", "🤪", "😉", "😌", "🥰", "😘"]
    var buttonFace: some View {
        Button {
            emojis = faces.shuffled()
            emojiCount = faces.count
        } label: {
            VStack {
                Image(systemName: "face.smiling")
                    .font(.largeTitle)
                Text("face")
            }
        }
    }
    
    let foods = ["🍏", "🍌", "🍐", "🍉", "🍒", "🍈", "🫐", "🥭", "🍍", "🥥", "🍆", "🍅", "🥝", "🌽", "🫒"]
    var buttonFood: some View {
        Button {
            emojis = foods.shuffled()
            emojiCount = foods.count
        } label: {
            VStack {
                Image(systemName: "applelogo")
                    .font(.largeTitle)
                Text("food")
                    .allowsTightening(true)
            }
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
