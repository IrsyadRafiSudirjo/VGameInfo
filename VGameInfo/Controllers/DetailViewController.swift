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

        // Do any additional setup after loading the view.
        
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

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.gameImageDetail.image = image
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
