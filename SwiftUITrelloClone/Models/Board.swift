//
//  Board.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class Board:
    ObservableObject,
    Identifiable
{
    private(set) var id = UUID()
    @Published var name: String
    @Published var boardLists: [BoardList]
    
    init(
        boardLists: [BoardList] = [],
        name: String
    ) {
        self.boardLists = boardLists
        self.name = name
    }
    
    func move(
        card: Card,
        to boardList: BoardList,
        at index: Int
    ) {
        guard let sourceBoardListIndex = boardListIndex(id: card.boardListId),
              let destinationBoardListIndex = boardListIndex(id: boardList.id),
              sourceBoardListIndex != destinationBoardListIndex,
              let sourceCardIndex = cardIndex(
                id: card.id,
                boardIndex: sourceBoardListIndex
              ) else { return }
        
        boardList.cards.insert(
            card,
            at: index
        )
        card.boardListId = boardList.id
        boardLists[sourceBoardListIndex].cards.remove(at: sourceCardIndex)
    }
}

// MARK: Private Functions

private extension Board {
    func boardListIndex(id: UUID) -> Int? {
        boardLists.firstIndex { $0.id == id }
    }
    
    func cardIndex(
        id: UUID,
        boardIndex: Int
    ) -> Int?  {
        boardLists[boardIndex].cardIndex(id: id)
    }
}
