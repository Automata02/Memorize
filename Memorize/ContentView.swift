//
//  ContentView.swift
//  Memorize
//
//  Created by roberts.kursitis on 30/01/2023.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: EmojiMemoryGame
	
//	var emojis: [String] {
//		switch selectedTheme {
//		case .smileys:
//			return ["💀", "🥰", "😅", "😔",
//					"🥶", "🥵", "😭", "😎",
//					"🤮", "😳", "🤯", "😡",
//					"😟", "🤩", "🤓"].shuffled()
//		case .vehicles:
//			return ["🚗", "🚙", "🚌", "🏎️",
//					"🚑", "🚓", "🛵", "✈️",
//					"🚃", "🚢", "🚁", "⛵️",
//					"🚂", "🛶",].shuffled()
//		case .numbers:
//			return ["0️⃣", "1️⃣", "2️⃣", "3️⃣",
//					"4️⃣", "5️⃣", "6️⃣", "7️⃣",
//					"8️⃣", "9️⃣", "🔟", "#️⃣",
//					"*️⃣"].shuffled()
//		case .hands:
//			return ["👏", "🤝", "👍", "👎",
//					"✊", "✌️", "✌️", "🤟",
//					"👌", "🤌", "🤏", "🤙"].shuffled()
//		}
//	}
	
//	@State var emojiCount = 8
	
	var colors: [Color] = [.red, .orange, .green, .pink, .blue]
	@State var selectedColor: Color = .green
	
	@State private var selectedTheme = Themes.smileys
	enum Themes: String, CaseIterable {
		case smileys, vehicles, numbers, hands
	}
	let titles = ["smileys": "face.smiling.inverse",
				  "vehicles": "car.fill",
				  "numbers": "number.circle.fill",
				  "hands": "hand.raised.fill"]
	@State private var isShowingSettings = false
	
    var body: some View {
		NavigationView {
			VStack {
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 80, maximum: 90)), count: 4)) {
						ForEach(viewModel.cards) { card in
							CardView(card: card, color: selectedColor)
								.aspectRatio(2/3, contentMode: .fit)
								.onTapGesture {
									viewModel.choose(card)
								}
						}
					}
				}
				Spacer()
				if isShowingSettings {
					VStack {
						Text("Pick a theme!")
							.font(.title)
						Picker("", selection: $selectedTheme) {
							ForEach(Themes.allCases, id: \.self) { theme in
								Label(theme.rawValue.capitalized, systemImage: titles[theme.rawValue] ?? "")
							}
						}
						HStack {
							ForEach(colors, id: \.self) { color in
								Image(systemName: "circle.fill")
									.foregroundColor(color)
									.onTapGesture {
										selectedColor = color
									}
							}
						}
						.font(.largeTitle)
						.padding()
					}
				}
			}
			.navigationTitle("Memorize")
			.toolbar {
				Button {
					isShowingSettings.toggle()
				} label: {
					Image(systemName: "gearshape.fill")
						.foregroundColor(.primary)
				}
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
		ContentView(viewModel: game)
    }
}

struct CardView: View {
	var card: MemoryGame<String>.Card
	var color: Color
	
	var body: some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: 25)
			
			if card.isFaceUp {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: 3).foregroundColor(color)
				Text(card.content).foregroundColor(.orange).font(.largeTitle)
			} else if card.isMatched {
				shape.opacity(0)
			} else {
				shape.fill().foregroundColor(color)
			}
		}
		.padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
	}
}
