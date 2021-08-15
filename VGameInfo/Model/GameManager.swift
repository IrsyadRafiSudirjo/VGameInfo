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
    
    
    
    let gameURL = "https://api.rawg.io/api/games?page_size=10&key=982f3178fb6a49b4b397fe36beffcaeb"
    
    let searchGameURL = "https://api.rawg.io/api/games?key=982f3178fb6a49b4b397fe36beffcaeb"
    
    
    
    var delegate : GameManagerDelegate?
    
    
    func fetchGame() {
        let urlString = "\(gameURL)"
        performRequest(with: urlString)
    }
    
    
    func searchGame(query : String)  {
        let urlString = "\(searchGameURL)&search=\(query)"
        print(urlString)
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
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    
    
    
}


