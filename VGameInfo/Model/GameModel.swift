//
//  GameModel.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 14/08/21.
//

import Foundation


struct GameModel : Codable {
    let id: Int
    let background_image: String
    let name: String
    let rating: Double
    let released: String

    
    
}

func fetchDetailGame(_ id : Int) {
    let detailGameURL = "https://api.rawg.io/api/games/\(id)?key=982f3178fb6a49b4b397fe36beffcaeb"
    
}


