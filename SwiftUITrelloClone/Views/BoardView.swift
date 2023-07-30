//
//  BoardView.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 19/7/23.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var board = BoardDiskRepository().loadBoardFromDisk() ?? Board.stub
    @State private var dragging: BoardList?
    
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
                        .onDrag({
                            self.dragging = boardList
                            
                            return NSItemProvider(object: boardList)
                        })
                        
                        .onDrop(
                            of: [
                                Card.typeIdentifier,
                                BoardList.typeIdentifier
                            ],
                            delegate: BoardDropDelegate(
                                board: board,
                                boardList: boardList,
                                boardLists: $board.boardLists,
                                current: $dragging
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
            .toolbar {
                Button("Rename") {
                    renameBoardView()
                }
            }
        }
        .edgesIgnoringSafeArea([.bottom])
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                BoardDiskRepository().saveBoardToDisk(board)
            }
    }
    
    private func handleOnAddList() {
        presentAlertTextField(
            title: "Add list") { name in
                guard let name = name, !name.isEmpty else { return }
                board.addNewBoardListWithName(name)
            }
    }
}

// MARK: - Private Functions

private extension BoardView {
    func renameBoardView() {
        presentAlertTextField(
            title: "Rename Board",
            defaultText: board.name) { newBoardName in
                guard let newBoardName = newBoardName,
                      !newBoardName.isEmpty else { return }
                board.name = newBoardName
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
