//
//  BoardListView.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 19/7/23.
//

import SwiftUI

struct BoardListView: View {
    @ObservedObject var board: Board
    @StateObject var boardList: BoardList
    @State var listHeight: CGFloat = 0
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            headerView
            
            listView
                .listStyle(.plain)
                .padding(.top, 16)
            
            Button("+ Add Card") {
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical)
        .background(Color.boardListBackgroundColor)
        .frame(width: 310)
        .cornerRadius(8)
        .foregroundColor(.black)
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text(boardList.name)
                .font(.headline)
                .lineLimit(2)
            
            Spacer()
            
            Menu {
                Button("Rename") {
                    
                }
                
                Button(
                    "Delete",
                    role: .destructive
                ) {
                    
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List {
            ForEach(boardList.cards) { card in
                CardView(
                    boardList: boardList,
                    card: card
                )
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(
                top: 4,
                leading: 8,
                bottom: 4,
                trailing: 8
            ))
            .listRowBackground(Color.clear)
        }

    }
}

struct BoardListView_Previews: PreviewProvider {
    @StateObject static var board = Board.stub
    
    static var previews: some View {
        BoardListView(
            board: board,
            boardList: board.boardLists[0]
        )
        .previewLayout(.sizeThatFits)
        .frame(
            width: 310,
            height: 512
        )
    }
}
