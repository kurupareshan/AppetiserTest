//
//  ListTableViewCell.swift
//  Appetiser
//
//  Created by kurupareshan pathmanathan on 5/30/22.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(name: String, artWork: String, price: Double, genre: String) {
        self.trackName.text = name
        self.price.text = String(price)
        self.genre.text = genre
        icon.layer.borderWidth = 1.0
        icon.layer.masksToBounds = false
        icon.layer.borderColor = UIColor.white.cgColor
        icon.layer.cornerRadius = icon.frame.size.width / 2
        icon.clipsToBounds = true
        likeButton.layer.borderWidth = 1.0
        likeButton.layer.masksToBounds = false
        likeButton.layer.borderColor = UIColor.white.cgColor
        likeButton.layer.cornerRadius = icon.frame.size.width / 2
        likeButton.clipsToBounds = true
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.icon.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
