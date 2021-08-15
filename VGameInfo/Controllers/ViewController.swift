//
//  ViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 08/08/21.
//

import UIKit

class ViewController: UIViewController , GameManagerDelegate, UITextFieldDelegate{
   
    
    var gameList : [Results] = []
   
    

    @IBOutlet weak var gameTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    var gameManager = GameManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.delegate = self
        searchTextField.delegate = self

        
        self.navigationItem.title = "Detail Game"

        // Menghubungkan heroTableView dengan ke dua metode di bawah
        gameTableView.dataSource = self
            
        gameTableView.delegate = self

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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldEdit()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type City"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            let newString = city.replacingOccurrences(of: " ", with: "%20")
            gameManager.searchGame(query: newString)
        }
        
        searchTextField.text = ""
    }
    
    func textFieldEdit() {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
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
            setImage(from: game.background_image ?? "https://media.rawg.io/media/screenshots/d82/d825bac6643ca4ed5a89e569245ca508.jpg")
            
            // Kode ini digunakan untuk membuat imageView memiliki frame bound/lingkaran
            

            return cell
        } else {
            return UITableViewCell()
        }

       
    }
    
    
    

}

extension ViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Memanggil View Controller dengan berkas NIB/XIB di dalamnya
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        // Mengirim data hero
        detail.result = gameList[indexPath.row]
        
        // Push/mendorong view controller lain
        self.navigationController?.pushViewController(detail, animated: true)
    }


}
