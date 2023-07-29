//
//  BoardView.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 19/7/23.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var board = Board.stub
    
    var body: some View {
        ZStack {
            Image("office")
                .resizable()
//                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.horizontal) {
                Spacer()

                LazyHStack(
                    alignment: .top,
                    spacing: 24
                ) {
                    ForEach(board.boardLists) { boardList in
                        BoardListView(
                            board: board,
                            boardList: boardList
                        )
                        .onDrop(
                            of: [Card.typeIdentifier],
                            delegate: BoardDropDelegate(
                                board: board,
                                boardList: boardList
                            )
                        )
                    }
                    
                    Button("+ Add list") {
                        handleOnAddList()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.boardListBackgroundColor.opacity(0.8))
                    .frame(width: 310)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                }
                .padding()
                .animation(.default, value: board.boardLists)
            }
            .background(.clear)
            .navigationTitle("String")
        }
        .edgesIgnoringSafeArea([.bottom])
    }
    
    private func handleOnAddList() {
        presentAlertTextField(
            title: "Add list") { name in
                guard let name = name, !name.isEmpty else { return }
                board.addNewBoardListWithName(name)
            }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
