//
//  Card.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class Card: ObservableObject, Identifiable {
    private(set) var id = UUID()
    var boardListId: UUID
    @Published var content: String
    
    init(
        boardListId: UUID,
        content: String
    ) {
        self.boardListId = boardListId
        self.content = content
    }
}
