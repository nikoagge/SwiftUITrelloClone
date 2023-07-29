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
                handleAddCard()
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
                    renameBoardList()
                }
                
                Button(
                    "Delete",
                    role: .destructive
                ) {
                    board.removeBoardList(boardList)
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
                .onDrag {
                    NSItemProvider(object: card)
                }
            }
            .onInsert(
                of: [Card.typeIdentifier],
                perform: onInsertCard
            )
            .onMove(perform: boardList
                .moveCards
            )
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

// MARK: - Private Functions

private extension BoardListView {
    func handleAddCard() {
        presentAlertTextField(
            title: "Add card to \(boardList.name)"
        ) { contentText in
                guard let contentText = contentText, !contentText.isEmpty else { return }
                boardList.addNewCard(with: contentText)
        }
    }
    
    func onInsertCard(
        index: Int,
        itemProviders: [NSItemProvider]
    ) {
        for itemProvider in itemProviders {
            itemProvider.loadObject(
                ofClass: Card.self) { itemProviderReading, _ in
                    guard let card = itemProviderReading as? Card else { return }
                    DispatchQueue.main.async {
                        board.move(
                            card: card,
                            to: boardList,
                            at: index
                        )
                    }
                }
        }
    }
    
    func renameBoardList() {
        presentAlertTextField(
            title: "Rename list",
            defaultText: boardList.name
        ) { name in
            guard let name = name, !name.isEmpty else { return }
            boardList.name = name
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
