//
//  BoardDiskRepository.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 30/7/23.
//

import Foundation

struct BoardDiskRepository {
    private var savePathURL: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("board.trl")
    }
    
    func loadBoardFromDisk() -> Board? {
        guard let data = try? Data(contentsOf: savePathURL) else { return nil }
        
        return try? JSONDecoder().decode(
            Board.self,
            from: data
        )
    }
    
    func saveBoardToDisk(_ board: Board) {
        guard let data = try? JSONEncoder().encode(board) else { return }
        try? data.write(
            to: savePathURL,
            options: .atomic
        )
    }
}
