//
//  EmojiMemoryGame+ViewModel.swift
//  Memorize
//
//  Created by roberts.kursitis on 31/01/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
	static let emojis = ["💀", "🥰", "😅", "😔", "🥶", "🥵", "😭", "😎", "🤮", "😳", "🤯", "😡", "😟", "🤩", "🤓"]
	
	static func createMemoryGame() -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
			emojis[pairIndex]
		}
	}
	
	@Published private var model: MemoryGame<String> = createMemoryGame()
//	MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
//		emojis[pairIndex]
//	}
	
	var cards: Array<MemoryGame<String>.Card> {
		return model.cards
	}
	
	//MARK: Intent(s)
	func choose(_ card: MemoryGame<String>.Card) {
		model.choose(card)
	}
}

