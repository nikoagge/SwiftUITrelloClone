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
    
    func dropInfoUpdated(dropInfo: DropInfo) -> DropProposal? {
        if !cardItemProviders(dropInfo: dropInfo).isEmpty {
            return DropProposal(operation: .copy)
        }
        
        return nil
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
        
        return true
    }
    
    private func cardItemProviders(dropInfo: DropInfo) -> [NSItemProvider] {
        dropInfo.itemProviders(for: [Card.typeIdentifier])
    }
}
