//
//  DetailViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 14/08/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameImageDetail: UIImageView!
    
    
    @IBOutlet weak var gameTitleDetail: UILabel!
    
    
    @IBOutlet weak var gameReleaseDateDetail: UILabel!
    
    @IBOutlet weak var gameRatingDetail: UILabel!
    
    @IBOutlet weak var gameDescriptionDetail: UILabel!
    
    
    var result: Results?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if result != nil {
            setImage(from: result!.background_image ?? "https://media.rawg.io/media/screenshots/d82/d825bac6643ca4ed5a89e569245ca508.jpg")
            gameTitleDetail.text = result?.name
            gameReleaseDateDetail.text = result?.released
            gameRatingDetail.text = result?.ratingString
            gameDescriptionDetail.text = result?.updated
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

}
