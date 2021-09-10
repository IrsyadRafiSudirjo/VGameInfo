//
//  FavoriteViewController.swift
//  VGameInfo
//
//  Created by Muhammad Irsyad Rafi on 08/09/21.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate {

    private var games: [Results] = []
    private var gamesId: Int = 0
    private lazy var gameProvider: GameProvider = { return GameProvider() }()
    
    @IBOutlet weak var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMembers()
    }
    
    private func loadMembers() {
        self.gameProvider.getAllGames { result in
               DispatchQueue.main.async {
                   self.games = result
                print(result)
                   self.favoriteTableView.reloadData()
               }
           }
    }
    
    private func setupView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
}
 
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
         let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
         detail.result = games[indexPath.row]
         self.navigationController?.pushViewController(detail, animated: true)
     }
}

