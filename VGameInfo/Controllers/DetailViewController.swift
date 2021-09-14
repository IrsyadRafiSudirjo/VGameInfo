//
//  DetailViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 14/08/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private lazy var memberProvider: GameProvider = { return GameProvider() }()
    var gamerId: Int = 0

    @IBOutlet weak var gameImageDetail: UIImageView!
    @IBOutlet weak var gameTitleDetail: UILabel!
    @IBOutlet weak var gameReleaseDateDetail: UILabel!
    @IBOutlet weak var gameRatingDetail: UILabel!
    @IBOutlet weak var gameDescriptionDetail: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var result: Results?
    override func viewDidLoad() {
        super.viewDidLoad()
        if result != nil {
            gamerId = result?.id ?? 0
            setImage(from: result!.background_image ?? "https://media.rawg.io/media/screenshots/d82/d825bac6643ca4ed5a89e569245ca508.jpg")
            gameTitleDetail.text = result?.name
            gameReleaseDateDetail.text = result?.released
            gameRatingDetail.text = result?.ratingString
            gameDescriptionDetail.text = result?.updated
            memberProvider.checkGameExist(gameId: self.gamerId) { id in
                if id == self.gamerId{
                    self.favoriteButton.setTitle("Unfavorite", for: .normal)
                }
                else{
                    self.favoriteButton.setTitle("Favorite", for: .normal)
                }
            }
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.gameImageDetail.image = image
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if result != nil {
            memberProvider.checkGameExist(gameId: self.gamerId) { id in
            if id == self.gamerId {
                self.favoriteButton.setTitle("favorite", for: .normal)
                self.memberProvider.deleteGame(id) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: "Game deleted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                self.favoriteButton.setTitle("Unfavorite", for: .normal)
                self.memberProvider.createGame(self.result?.id ?? 0,self.result?.name ?? "13", self.result!.background_image ?? "https://media.rawg.io/media/screenshots/d82/d825bac6643ca4ed5a89e569245ca508.jpg", self.result?.rating ?? 0.0,  self.result?.released ?? "11", self.result?.updated ?? "12") {
                DispatchQueue.main.async {
                 let alert = UIAlertController(title: "Successful", message: "New Game added to favorite.", preferredStyle: .alert)
                                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                    }
                }
             }
           }
        }
    }
}
