//
//  CardView.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 19/7/23.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var boardList: BoardList
    @StateObject var card: Card
    
    var body: some View {
        HStack {
            Text(card.content)
                .lineLimit(3)
            
            Spacer()
            
            Menu {
                Button("Edit") { handleEdit() }
                
                Button(
                    "Delete",
                    role: .destructive
                ) { handleDelete() }
            } label: {
                Image(systemName: "ellipsis.rectangle")
                    .imageScale(.small)
            }
        }
        .padding(8)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(.white)
        .cornerRadius(4)
        .shadow(
            radius: 1,
            y: 1
        )
    }
}

struct CardView_Previews: PreviewProvider {
    @StateObject static var boardList = Board.stub.boardLists[0]
    
    static var previews: some View {
        CardView(
            boardList: boardList,
            card: boardList.cards[0]
        )
        .previewLayout(.sizeThatFits)
        .frame(width: 310)
    }
}

// MARK: - Extension

private extension CardView {
    func handleEdit() {
        presentAlertTextField(
            title: "Edit Card",
            defaultText: card.content
        ) { newContentText in
            guard let newContentText = newContentText, !newContentText.isEmpty else { return }
            card.content = newContentText
        }
    }
    
    func handleDelete() {
        boardList.removeCard(card)
    }
}
