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
    
    mutating func choose(card: Card) -> Double? {
        if let chosenIndex: Int = index(of: card),
           !cards[chosenIndex].isFlipped,
           !cards[chosenIndex].isMatched {
            
            if let potencialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                
                if cards[chosenIndex].content == cards[potencialMatchIndex].content {
                    
                    cards[chosenIndex].isMatched = true
                    cards[potencialMatchIndex].isMatched = true
                    
                    let bonus1 = cards[chosenIndex].bonusRemaining
                    let bonus2 = cards[potencialMatchIndex].bonusRemaining
                    let averageBonus = (bonus1 + bonus2) / 2
                    
                    return averageBonus
                }
                
                cards[chosenIndex].isFlipped = true
                return 0
                
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        return nil
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
        var isFlipped: Bool = false {
            didSet {
                if isFlipped {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?

        var pastFaceUpTime: TimeInterval = 0
        
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFlipped && !isMatched && bonusTimeRemaining > 0
        }
        
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
}
