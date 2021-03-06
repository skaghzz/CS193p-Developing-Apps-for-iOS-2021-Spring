//
//  ContentView.swift
//  Memorize
//
//  Created by 60080341 on 2021/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var emojis = ["π²", "π","π", "π", "π", "π", "π", "π", "π", "βοΈ", "π", "β΅οΈ",  "πΈ", "πΆ", "π", "π", "πΊ", "π ", "π΅", "π", "π", "π", "π»", "π"].shuffled()
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
    
    let vehicles = ["π²", "π","π", "π", "π", "π", "π", "π", "π", "βοΈ", "π", "β΅οΈ",  "πΈ", "πΆ", "π", "π", "πΊ", "π ", "π΅", "π", "π", "π", "π»", "π"]
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
    
    let faces = ["π", "π", "π", "π", "π", "π€£", "π₯²", "βΊοΈ", "π", "π", "π", "π€ͺ", "π", "π", "π₯°", "π"]
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
    
    let foods = ["π", "π", "π", "π", "π", "π", "π«", "π₯­", "π", "π₯₯", "π", "π", "π₯", "π½", "π«"]
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
