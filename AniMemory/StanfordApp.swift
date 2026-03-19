//
//  StanfordApp.swift
//  Stanford
//
//  Created by Wesley Nogueira on 05/03/26.
//

import SwiftUI

@main
struct AniMemoryApp: App {
    var body: some Scene {
        WindowGroup {
            ImageMemoryGameView(viewModel: ImageMemoryGame())
        }
    }
}
