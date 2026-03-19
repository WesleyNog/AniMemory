//
//  ImageMemoryGame.swift
//  Stanford
//
//  Created by Wesley Nogueira on 05/03/26.
//

import SwiftUI
import Combine


class ImageMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = ImageMemoryGame.createMemoryGame()
    
    @Published var score: Int = 0
    @Published var lastScoreGain: Int = 0
    @Published var scoreTrigger = UUID()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let images: [String] = ["luffy", "zoro", "sanji", "nami", "usop", "choper", "robin", "brook", "frank", "ginbe"]
//        let images: [String] = ["naruto", "sasuke", "sakura", "kakashi", "gay", "chicamaru", "hinata", "gaara", "itachi", "jyraia"]
        return MemoryGame<String>(numberPairCards: images.count) {
        pairIndex in return images[pairIndex]
        }
    }
    
    //MARK: - Acesso
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    //MARK: - Intenção
    func choose(card: MemoryGame<String>.Card) {
        let result = model.choose(card: card)
        print(result)
        
        guard let bonus = result else { return } // primeira carta
        
        if bonus > 0 {
            let points = Int(5 + 25 * bonus)
            score += points
            lastScoreGain = points
        } else {
            score -= 2
            lastScoreGain = -2
        }
        
        scoreTrigger = UUID()
    }
    
    func resetGame() {
        model = ImageMemoryGame.createMemoryGame()
        score = 0
    }
}

