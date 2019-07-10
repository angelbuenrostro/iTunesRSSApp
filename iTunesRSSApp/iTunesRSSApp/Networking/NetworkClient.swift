//
//  NetworkClient.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit


enum MediaType: String {
    case appleMusic = "apple-music"
    case audioBooks = "audiobooks"
    case tvShows = "tv-shows"
}

class NetworkClient {
    // Base iTunes RSS URL
    private let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/")!
    
    // Fetches results from given URL and decodes them into our model object
    func fetchRSS(mediaType: String = "apple-music", resultLimit: Int = 12,
                  completion: @escaping ([Result]?, Error?) -> Void) {
        
        var feedType = "coming-soon"
        
        switch mediaType {
        case MediaType.appleMusic.rawValue:
            feedType = "coming-soon"
        case MediaType.audioBooks.rawValue:
            feedType = "top-audiobooks"
        case MediaType.tvShows.rawValue:
            feedType = "top-tv-episodes"
        default:
            break
        }
        
        // Make valid URL
        let url = baseURL.appendingPathComponent(mediaType)
                            .appendingPathComponent(feedType)
                            .appendingPathComponent("all")
                            .appendingPathComponent("\(resultLimit)")
                            .appendingPathComponent("explicit")
                            .appendingPathExtension("json")
        
        // Make valid URL request
        let requestURL = URLRequest(url: url)
        print(requestURL)
        // Start the data task
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            // Catch initial request error
            if let error = error {
                NSLog("Error fetching data: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            // Catch no data error
            guard let data = data else {
                NSLog("Error. No data.")
                completion(nil, NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                // Try decoding data into model, if error return description
                let rss = try jsonDecoder.decode(Feed.self, from: data)
                completion(rss.results, nil)
            } catch {
                NSLog("Error decoding data: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}

