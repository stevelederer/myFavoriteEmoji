//
//  Person.swift
//  myFavoriteEmoji
//
//  Created by Steve Lederer on 12/12/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

struct Person: Codable {
    let name: String
    let favoriteEmoji: String
    
    init(name: String, favoriteEmoji: String) {
        self.name = name
        self.favoriteEmoji = favoriteEmoji
    }
}
