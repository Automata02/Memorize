//
//  ContentView.swift
//  Memorize
//
//  Created by roberts.kursitis on 30/01/2023.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: EmojiMemoryGame
	@State private var isShowingSettings = false
	
    var body: some View {
		NavigationView {
			VStack {
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 80, maximum: 90)), count: 4)) {
						ForEach(viewModel.cards) { card in
							CardView(card: card, color: viewModel.selectedColor)
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
						Picker("", selection: $viewModel.selectedTheme) {
							ForEach(EmojiMemoryGame.Themes.allCases, id: \.self) { theme in
								Label(theme.rawValue.capitalized, systemImage: EmojiMemoryGame.titles[theme.rawValue] ?? "")
							}
						}
						HStack {
							ForEach(EmojiMemoryGame.colors, id: \.self) { color in
								Image(systemName: "circle.fill")
									.foregroundColor(color)
									.onTapGesture {
										viewModel.changeThemeColor(color)
									}
							}
						}
						.font(.largeTitle)
						.padding()
					}
				} else {
					Text("Score: \(viewModel.fetchScore())")
				}
			}
			.navigationTitle(viewModel.currentTheme.title.capitalized)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						viewModel.restartGame()
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
