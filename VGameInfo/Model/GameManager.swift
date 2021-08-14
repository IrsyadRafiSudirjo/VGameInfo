//
//  GameManager.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 11/08/21.
//

import Foundation
import CoreLocation



protocol GameManagerDelegate {
    func didUpdateWeather(_ gameManager : GameManager, gameData: GameModel)
    func didFailWithError(error : Error)
}


struct GameManager{
    let gameURL = "https://api.rawg.io/api/games?key=982f3178fb6a49b4b397fe36beffcaeb"

    
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
                        self.delegate?.didUpdateWeather(self , gameData: game)
                    }
                }
            }
            
            
            //start task
            task.resume()
            
        }
    }
    
    func parseJSON(_ gameData : Data) -> GameModel?  {
    let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Game.self, from: gameData)
            let id = decodedData.results[0].id
            let background_image = decodedData.results[0].background_image
            let name = decodedData.results[0].name
            let rating = decodedData.results[0].rating
            let released = decodedData.results[0].released

            
            let game = GameModel(id: id, background_image: background_image, name: name, rating: rating, released: released)
            return game
            
//            print(weather.conditionName)
//            print(weather.temperatureString)
        }
        catch{
         delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}


