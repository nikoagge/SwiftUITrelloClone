//
//  Card.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 18/7/23.
//

import Foundation

class Card:
    NSObject,
    ObservableObject,
    Identifiable,
    Codable
{
    private(set) var id = UUID()
    var boardListId: UUID
    @Published var content: String
    
    init(
        boardListId: UUID,
        content: String
    ) {
        self.boardListId = boardListId
        self.content = content
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.boardListId = try container.decode(UUID.self, forKey: .boardListId)
        self.content = try container.decode(String.self, forKey: .content)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boardListId, forKey: .boardListId)
        try container.encode(content, forKey: .content)
        try container.encode(id, forKey: .id)
    }
    
    enum CodingKeys: String, CodingKey {
        case boardListId, content, id
    }
}

// MARK: - NSItemProviderWriting

extension Card: NSItemProviderWriting {
    static let typeIdentifier = "com.napps.SwiftUITrelloClone.Card"
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

extension Card: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
