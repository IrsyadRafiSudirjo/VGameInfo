//
//  ViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 08/08/21.
//

import UIKit

class ViewController: UIViewController , GameManagerDelegate{
   
    
    var gameList : [Results] = []
   
    

    @IBOutlet weak var gameTableView: UITableView!
    
    var gameManager = GameManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.delegate = self

        
        // Menghubungkan heroTableView dengan ke dua metode di bawah
        gameTableView.dataSource = self
            
        // Menghubungkan berkas XIB untuk HeroTableViewCell dengn heroTableView.
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")

        
        gameManager.fetchGame()
        

    }


    
    
    func didUpdateGame(_ gameManager: GameManager, gameData: [Results]) {
        gameList = gameData
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        print("gagal")
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            
            // Menetapkan nilai hero ke view di dalam cell
            let game = gameList[indexPath.row]
            
          
            cell.gameTitle.text = game.name
            cell.gameDate.text = game.released
            cell.gameRating.text = game.ratingString
            
           
            func setImage(from url: String) {
                guard let imageURL = URL(string: url) else { return }

                    // just not to cause a deadlock in UI!
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }

                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.gameImage.image = image
                    }
                }
            }
            setImage(from: game.background_image)
            
            // Kode ini digunakan untuk membuat imageView memiliki frame bound/lingkaran
            

            return cell
        } else {
            return UITableViewCell()
        }

       
    }
    
    

}


