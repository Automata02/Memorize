//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by roberts.kursitis on 30/01/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
	@ObservedObject var game: EmojiMemoryGame
	@State private var isShowingSettings = false
	
    var body: some View {
		NavigationView {
			VStack {
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 80, maximum: 90)), count: 4)) {
						ForEach(game.cards) { card in
							CardView(card, game.selectedColor)
								.aspectRatio(2/3, contentMode: .fit)
								.onTapGesture {
									game.choose(card)
								}
						}
					}
				}
				Spacer()
				if isShowingSettings {
					VStack {
						Text("Pick a theme!")
							.font(.title)
						Picker("", selection: $game.selectedTheme) {
							ForEach(EmojiMemoryGame.Themes.allCases, id: \.self) { theme in
								Label(theme.rawValue.capitalized, systemImage: EmojiMemoryGame.titles[theme.rawValue] ?? "")
							}
						}
						HStack {
							ForEach(EmojiMemoryGame.colors, id: \.self) { color in
								Image(systemName: "circle.fill")
									.foregroundColor(color)
									.onTapGesture {
										game.changeThemeColor(color)
									}
							}
						}
						.font(.largeTitle)
						.padding()
					}
				} else {
					Text("Score: \(game.fetchScore())")
				}
			}
			.navigationTitle(game.currentTheme.title.capitalized)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						game.restartGame()
					} label: {
						Image(systemName: "arrow.clockwise.circle.fill")
							.foregroundColor(.primary)
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
		EmojiMemoryGameView(game: game)
    }
}

struct CardView: View {
	private let card: MemoryGame<String>.Card
	var color: Color
	
	init(_ card: EmojiMemoryGame.Card, _ color: Color) {
		self.card = card
		self.color = color
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
				
				if card.isFaceUp {
					shape.fill().foregroundColor(.white)
					shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(color)
					Text(card.content).font(font(in: geometry.size))
				} else if card.isMatched {
					shape.opacity(0)
				} else {
					shape.fill().foregroundColor(color)
				}
			}
			.padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
		}
	}
	
	private func font(in size: CGSize) -> Font {
		Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
	}
	
	private struct DrawingConstants {
		static let cornerRadius: CGFloat = 10
		static let lineWidth: CGFloat = 3
		static let fontScale: CGFloat = 0.8
	}
}
