//
//  Feed.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation

struct Feed: Decodable {
    let results: [Result]
    
    enum JSONCodingKeys: String, CodingKey {
        case feed
    }
    
    enum FeedCodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONCodingKeys.self)
        let feedContainer = try container.nestedContainer(keyedBy: FeedCodingKeys.self, forKey: .feed)
        var resultsContainer = try feedContainer.nestedUnkeyedContainer(forKey: .results)
        
        var results = [Result]()
        while !resultsContainer.isAtEnd {
            let result = try resultsContainer.decode(Result.self)
            results.append(result)
        }
        
        self.results = results
    }
}

