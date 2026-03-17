//
//  MemoryGame.swift
//  Stanford
//
//  Created by Wesley Nogueira on 05/03/26.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFlipped }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
        }
        set {
            for index in cards.indices {
                cards[index].isFlipped = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        print("Carta escolhida: \(card)")
        if let chosenIndex: Int = index(of: card), !cards[chosenIndex].isFlipped, !cards[chosenIndex].isMatched {
            if let potencialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potencialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potencialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFlipped = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    func index(of: Card) -> Int? {
        for i in 0..<cards.count {
            if cards[i].id == of.id {
                return i
            }
        }
        return nil
    }
    
    init(numberPairCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberPairCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFlipped: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
