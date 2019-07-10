//
//  Result.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class Result: Decodable, Equatable {
    let artistName: String
    let name: String
    let kind: String
    let artworkUrl100: String
    var image: UIImage? = nil
    
    enum ResultCodingKeys: String, CodingKey {
        case artistName, name, kind, artworkUrl100
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.name = try container.decode(String.self, forKey: .name)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.artworkUrl100 == rhs.artworkUrl100
    }
}

