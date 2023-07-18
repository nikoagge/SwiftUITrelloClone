//
//  BoardList.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class BoardList: NSObject, ObservableObject, Identifiable, Codable {
    private(set) var id = UUID()
    var boardId: UUID
    @Published var name: String
    @Published var cards: [Card]
    
    init(
        boardId: UUID,
        cards: [Card],
        name: String
    ) {
        self.boardId = boardId
        self.cards = cards
        self.name = name
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.boardId = try container.decode(UUID.self, forKey: .boardId)
        self.cards = try container.decode([Card].self, forKey: .cards)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boardId, forKey: .boardId)
        try container.encode(cards, forKey: .cards)
        try container.encode(id, forKey: .id)
    }
    
    enum CodingKeys: String, CodingKey {
        case boardId, cards, id, name
    }
}

// MARK: - NSItemProviderWriting

extension BoardList: NSItemProviderWriting {
    static let typeIdentifier = "com.napps.SwiftUITrelloClone.BoardList"
    static var writableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            completionHandler(try jsonEncoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return nil
    }
}

// MARK: - NSItemProviderReading

extension BoardList: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
