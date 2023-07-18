//
//  BoardList.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class BoardList: ObservableObject, Identifiable {
    private(set) var id = UUID()
    var boardId: UUID
    @Published var name: String
    @Published var cards: [Card]
    
    init(
        boardId: UUID,
        cards: [Card],
        name: String
    ) {
        self.boardId = boardId
        self.cards = cards
        self.name = name
    }
}
