//
//  ViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 08/08/21.
//

import UIKit

class ViewController: UIViewController , GameManagerDelegate{
   
    

    @IBOutlet weak var gameTableView: UITableView!
    
    var gameManager = GameManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.delegate = self

        gameManager.fetchGame()

        // Do any additional setup after loading the view.
    }


    
    
    func didUpdateWeather(_ gameManager: GameManager, gameData: GameModel) {
        print(gameData.name)
        print(gameData.id)
        print(gameData.rating)
        print(gameData.background_image)
        print(gameData.released)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //a
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //a
//
//    }
    
    


