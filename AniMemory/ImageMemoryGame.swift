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
        model.choose(card: card)
    }
    
    func resetGame() {
        model = ImageMemoryGame.createMemoryGame()
    }
}

