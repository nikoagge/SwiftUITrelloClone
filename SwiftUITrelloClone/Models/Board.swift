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
}
