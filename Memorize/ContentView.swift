//
//  ContentView.swift
//  Memorize
//
//  Created by Shawn Sui on 2025-02-27.
//

import SwiftUI

struct ContentView: View {
    enum Theme {
        case halloween
        case ocean
        case animals
    }

    let emojis: [Theme: [String]] = [
        Theme.halloween: ["🎃", "👻", "🕷️", "👹", "🍭", "🙀", "🪓", "💀"],
        Theme.ocean: ["🌊", "🐠", "🐬", "🐟", "🐙", "🐚", "🐦", "🐧"],
        Theme.animals: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐨"]
    ]

    let colors: [Theme: Color] = [
        .halloween: .orange,
        .ocean: .blue,
        .animals: .green
    ]

    @State var cardCount = 4
    @State var currentTheme: Theme = .halloween

    var body: some View {
        VStack {
            header
            ZStack(alignment: .bottom) {
                ScrollView {
                    cards
                }
                cardThemeAdjuster
            }
        }
        .padding([.horizontal], 20)
    }

    var header: some View {
        HStack {
            cardRemover
            Spacer()
            Text("Memorize!")
                .font(.system(size: 40, weight: .bold))
            Spacer()
            cardAdder
        }
        .imageScale(.large)
    }

    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0 ..< cardCount, id: \.self) { index in
                CardView(content: emojis[currentTheme]![index])
                    .aspectRatio(2 / 3, contentMode: .fit)
            }
        }
        .foregroundColor(colors[currentTheme])
    }

    var cardThemeAdjuster: some View {
        HStack(spacing: 50) {
            cardThemeAdjuster(Theme.halloween, symbol: "wind")
            cardThemeAdjuster(Theme.animals, symbol: "cat.fill")
            cardThemeAdjuster(Theme.ocean, symbol: "drop.fill")
        }
        .padding()
        .background(.gray.opacity(0.2), in: Capsule())
    }

    func cardThemeAdjuster(_ theme: Theme, symbol: String) -> some View {
        Button(action: {
            currentTheme = theme
        }) {
            Image(systemName: symbol)
        }
    }

    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset

        }) {
            Image(systemName: symbol)
        }
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis[currentTheme]!.count)
    }

    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }

    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
    }
}

#Preview {
    ContentView()
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)

            Group {
                base.foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}
