//
//  MemoryGame+Model.swift
//  Memorize
//
//  Created by roberts.kursitis on 31/01/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
	private(set) var cards: Array<Card>
	
	private var indexOfOnlyFaceUpCard: Int?
	private(set) var seenCardArray: [Int] = []
	
	private(set) var score: Int = 0
	
	mutating func choose(_ card: Card) {
		if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
			if let potentialMatchIndex = indexOfOnlyFaceUpCard {
				if cards[chosenIndex].content == cards[potentialMatchIndex].content {
					cards[chosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
					score += 2
				} else {
					if seenCardArray.contains(chosenIndex) {
						score -= 1
					} else {
						seenCardArray.append(chosenIndex)
					}
					if seenCardArray.contains(potentialMatchIndex) {
						score -= 1
					} else {
						seenCardArray.append(potentialMatchIndex)
					}
				}
				indexOfOnlyFaceUpCard = nil
			} else {
				for index in cards.indices {
					cards[index].isFaceUp = false
				}
				indexOfOnlyFaceUpCard = chosenIndex
			}
			
			cards[chosenIndex].isFaceUp.toggle()
		}
		
		print("\(cards)")
	}
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = Array<Card>()
		//add numberOfPairsOfCards x 2 cards to cards array
		for pairIndex in 0..<numberOfPairsOfCards {
			let content = createCardContent(pairIndex)
			cards.append(Card(content: content, id: pairIndex*2))
			cards.append(Card(content: content, id: pairIndex*2+1))
		}
		
		cards = cards.shuffled()
		score = 0
	}
	
	struct Card: Identifiable {
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		var content: CardContent
		var id: Int
	}
}
