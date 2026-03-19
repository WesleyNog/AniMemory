//
//  ImageMemoryGameView.swift
//  Stanford
//
//  Created by Wesley Nogueira on 05/03/26.
//

import SwiftUI
import Foundation

struct ImageMemoryGameView: View {
    @ObservedObject var viewModel: ImageMemoryGame
    var body: some View {
        VStack {
            Text("One Piece")
                .font(Font.largeTitle)
                .foregroundColor(Color.blue)
                .fontWeight(Font.Weight.semibold)
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.5)) {
                                viewModel.choose(card: card)
                            }
                        }
                        .transition(AnyTransition.scale)
                }
            }
            
            Spacer()
            
            Text("Pontuação: 0")
                .padding()
                .font(Font.largeTitle)
                .foregroundColor(Color.blue)
                .fontWeight(.semibold)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        viewModel.resetGame()
                    }
                }
        }
        .padding(.horizontal, 5)
        .foregroundColor(Color.blue)
    }
    
    struct CardView: View {
        var card: MemoryGame<String>.Card
        var body: some View {
            ZStack {
                if card.isFlipped {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: lineWidth)
                    
                    TimelineView(.animation) { timeline in
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .trim(from: 0, to: card.bonusRemaining)
                            .stroke(lineWidth: lineWidth)
                            .opacity(0.5)
                            .padding(2.5)
                            .rotationEffect(Angle.degrees(-90))
                            .scaleEffect(x: -1, y: 1)
                    }
                    
                    Image(card.content)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(lineWidth: lineWidth)
                        Image("coverO")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            .frame(width: 90, height: 90)
            .padding(5)
            .scaleEffect(card.isMatched ? 0 : 1)
            .animation(.spring(response: 1, dampingFraction: 0.6), value: card.isMatched)
            .rotation3DEffect(Angle.degrees(card.isFlipped ? 0 : 180), axis: (0,1,0))
        }
        
        // MARK: - Criando Constantes
        
        private let cornerRadius: CGFloat = 20
        private let lineWidth: CGFloat = 3
        private let radius: CGFloat = 10
    }
    
}
#Preview {
    ImageMemoryGameView(viewModel: ImageMemoryGame())
}

