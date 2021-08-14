//
//  GameManager.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 11/08/21.
//

import Foundation
import CoreLocation



protocol GameManagerDelegate {
    func didUpdateGame(_ gameManager : GameManager, gameData: [Results])
    func didFailWithError(error : Error)
}


struct GameManager{
   // let gameURL = "https://api.rawg.io/api/games?key=982f3178fb6a49b4b397fe36beffcaeb"
    let gameURL = "https://api.rawg.io/api/games?page_size=10&key=982f3178fb6a49b4b397fe36beffcaeb"

   // let gameURL = "https://api.rawg.io/api/games?search=pokemon&key=982f3178fb6a49b4b397fe36beffcaeb&page_size=5"
 //   https://api.rawg.io/api/games/3498?key=982f3178fb6a49b4b397fe36beffcaeb

    
    var delegate : GameManagerDelegate?
   
    
    func fetchGame() {
        let urlString = "\(gameURL)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){

        if let url = URL(string: urlString){

            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data{
                    if let game = self.parseJSON(safeData){
                        self.delegate?.didUpdateGame(self , gameData: game)
                    }
                }

            }
            
            
            //start task
            task.resume()
            
        }
    }
    
    func parseJSON(_ gameData : Data) -> [Results]?  {
    let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Game.self, from: gameData).results
            return decodedData
        }
        catch{
         delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
}


