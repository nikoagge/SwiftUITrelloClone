//
//  Board+Extension.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

extension Board {
    static var stub: Board {
        let board = Board(name: "Dummy board")
        
        let backlogBoardList = BoardList(
            boardId: board.id,
            name: "Backlog"
        )
        let backlogCards = [
            "Cloud Services",
            "Compression Engine",
            "Database Services",
            "Maintenance",
            "Mobile Framework",
            "Deploying",
            "Analytics",
            "Crashlytics"
        ].map { Card(
            boardListId: backlogBoardList.id,
            content: $0
        ) }
        backlogBoardList.cards = backlogCards
        
        let toDoBoardList = BoardList(
            boardId: board.id,
            name: "To Do"
        )
        let toDoCards = [
            "Bug Fixing",
            "Talking With Client",
            "Onboarding Zoom",
            "Meditating",
            "Reading"
        ].map { Card(
            boardListId: toDoBoardList.id,
            content: $0
        ) }
        toDoBoardList.cards = toDoCards
        
        let inProgressBoardList = BoardList(
            boardId: board.id,
            name: "In Progress"
        )
        let inProgressCards = [
            "Writing Documentation",
            "Files Storage Service",
            "Alamofire Configuration"
        ].map { Card(
            boardListId: inProgressBoardList.id,
            content: $0
        ) }
        inProgressBoardList.cards = inProgressCards
        
        let doneBoardList = BoardList(
            boardId: board.id,
            name: "Done"
        )
        let doneCards = [
            "Closed Merge Request",
            "Fixed merged request's Comments",
            "Watched New WWDC Videos"
        ].map { Card(
            boardListId: doneBoardList.id,
            content: $0
        ) }
        doneBoardList.cards = doneCards
        
        board.boardLists = [
            backlogBoardList,
            toDoBoardList,
            inProgressBoardList,
            doneBoardList
        ]
        
        return board
    }
}
