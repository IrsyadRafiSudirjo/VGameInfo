//
//  Game.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 10/08/21.
//

import UIKit





struct Game : Codable {
    let results : [Results]
}

struct Results : Codable{
    let id: Int?
    let background_image: String?
    let name: String?
    let rating: Double
    let released: String?
    let updated: String?
    
    
    
    var ratingString : String {
        return String(format: "%.1f", rating)
    }
    
  
    
}


