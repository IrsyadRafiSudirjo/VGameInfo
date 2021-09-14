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
        gameTableView.dataSource = self
        gameTableView.delegate = self
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
            textField.placeholder = "Type Game"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = searchTextField.text{
            let newString = text.replacingOccurrences(of: " ", with: "%20")
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
            let game = gameList[indexPath.row]
            cell.gameTitle.text = game.name
            cell.gameDate.text = game.released
            cell.gameRating.text = game.ratingString
            func setImage(from url: String) {
                guard let imageURL = URL(string: url) else { return }
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.gameImage.image = image
                    }
                }
            }
            setImage(from: game.background_image ?? "https://media.rawg.io/media/screenshots/d82/d825bac6643ca4ed5a89e569245ca508.jpg")
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.result = gameList[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
