//
//  BoardDropDelegate.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 23/7/23.
//

import Foundation
import SwiftUI

struct BoardDropDelegate: DropDelegate {
    let board: Board
    let boardList: BoardList
    
    @Binding var boardLists: [BoardList]
    @Binding var current: BoardList?
    
    func dropInfoUpdated(dropInfo: DropInfo) -> DropProposal? {
        if !cardItemProviders(dropInfo: dropInfo).isEmpty {
            return DropProposal(operation: .copy)
        } else if !boardListItemProvider(dropInfo: dropInfo).isEmpty {
            return DropProposal(operation: .move)
        }
        
        return nil
    }
    
    func dropEntered(info: DropInfo) {
        guard !boardListItemProvider(dropInfo: info).isEmpty,
              let current = current,
              boardList != current,
              let fromIndex = boardLists.firstIndex(of: current),
              let toIndex = boardLists.firstIndex(of: boardList) else { return }
        boardLists.move(
            fromOffsets: IndexSet(integer: fromIndex),
            toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
        )
    }
    
    func performDrop(info: DropInfo) -> Bool {
        let cardItemProviders = cardItemProviders(dropInfo: info)
        for cardItemProvider in cardItemProviders {
            cardItemProvider.loadObject(ofClass: Card.self) { itemProviderReading, _ in
                guard let card = itemProviderReading as? Card,
                      card.boardListId != boardList.id else { return }
                
                DispatchQueue.main.async {
                    board.move(
                        card: card,
                        to: boardList,
                        at: 0
                    )
                }
            }
        }
        current = nil
        
        return true
    }
}

// MARK: - Private Functions

private extension BoardDropDelegate {
    func boardListItemProvider(dropInfo: DropInfo) -> [NSItemProvider] {
        dropInfo.itemProviders(for: [BoardList.typeIdentifier])
    }
    
    func cardItemProviders(dropInfo: DropInfo) -> [NSItemProvider] {
        dropInfo.itemProviders(for: [Card.typeIdentifier])
    }
}
