//
//  Board.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class Board:
    Codable,
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.boardLists = try container.decode([BoardList].self, forKey: .boardLists)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(
            id,
            forKey: .id
        )
        try container.encode(
            name,
            forKey: .name
        )
        try container.encode(
            boardLists,
            forKey: .boardLists
        )
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
    
    func addNewBoardListWithName(_ name: String) {
        boardLists.append(BoardList(
            boardId: id,
            name: name
        ))
    }
    
    func removeBoardList(_ boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else { return }
        boardLists.remove(at: index)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case boardLists = "lists"
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
