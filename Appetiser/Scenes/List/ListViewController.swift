//
//  ListViewController.swift
//  Appetiser
//
//  Created by kurupareshan pathmanathan on 5/30/22.
//

import UIKit

class ListViewController: UIViewController {

    var viewModel: ListViewModel? = nil
    var searching = false
    var searchArray = [String]()
    var likes = [String]()
    let userDefaults = UserDefaults.standard
    var offNameArray = [String]()
    var offPriceArray = [Double]()
    var offGenreArray = [String]()
    var selectedIndex = [Int]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var lastSeen: UILabel!
    
    public class var storyboardName: String {
        return "List"
    }
    
    static func create(viewModel: ListViewModel) -> ListViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: ListViewController.self)) as? ListViewController
        viewController!.viewModel = viewModel
        return viewController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        if let value = UserDefaults.standard.object(forKey: "date") as? Date {
            let day   = (Calendar.current.component(.day, from: value))
            let month = (Calendar.current.component(.month, from: value))
            let year = (Calendar.current.component(.year, from: value))
            lastSeen.text = "\("last seen : \(day):\(month):\(year)")"
        }else {
            lastSeen.text = "Welcome"
        }
        getListData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (viewModel?.isOffline == true) {
            offNameArray = userDefaults.stringArray(forKey: "name")!
            viewModel?.nameArray = offNameArray
            offPriceArray = userDefaults.array(forKey: "price") as? [Double] ?? [Double]()
            viewModel?.priceArray = offPriceArray
            offGenreArray = userDefaults.stringArray(forKey: "genre")!
            viewModel?.genreArray = offGenreArray
        }
        tableView.reloadData()
        for index in 0..<(viewModel?.nameArray.count)! {
            likes.append("like")
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        view.endEditing(true)
    }
    
    func getListData() {
        viewModel?.getData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return self.searchArray.count
        }else {
            return (viewModel?.nameArray.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        if (selectedIndex.contains(indexPath.row)) {
            cell.likeButton.setImage(UIImage(named: "like2"), for: .normal)
            cell.likeButton.backgroundColor = .red
        }else {
            cell.likeButton.setImage(UIImage(named: "like2"), for: .normal)
            cell.likeButton.backgroundColor = .clear
        }
        cell.likeButton.tag = indexPath.row
        var name = String()
        var artwork = String()
        var price = Double()
        var genre = String()
        if (searching) {
            name = (searchArray[indexPath.row])
            artwork = (viewModel?.imageURL[indexPath.row])!
            price = (viewModel?.priceArray[indexPath.row])!
            genre = (viewModel?.genreArray[indexPath.row])!
        }else {
            name = (viewModel?.nameArray[indexPath.row])!
            artwork = (viewModel?.imageURL[indexPath.row])!
            price = (viewModel?.priceArray[indexPath.row])!
            genre = (viewModel?.genreArray[indexPath.row])!
        }
        
        cell.setupView(name: name, artWork: artwork, price: price, genre: genre)
        if let array = userDefaults.stringArray(forKey: "name") {
            if (array.contains(cell.trackName.text!)) {
                cell.likeButton.backgroundColor = .red
            }else {
                cell.likeButton.backgroundColor = .clear
            }
        }
        cell.selectionStyle = .none
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath)
                as? ListTableViewCell else { return }
        if likes[sender.tag] == "like" {
            likes[sender.tag] = "unlike"
            sender.backgroundColor = .red
            selectedIndex.append(sender.tag)
            offNameArray.removeAll()
            var values = userDefaults.stringArray(forKey: "name")
            if (values != nil) {
                var trackName: String!
                if !(values!.contains(cell.trackName.text!)) {
                    trackName = cell.trackName.text!
                }
                if (trackName != nil) {
                    values?.append(trackName)
                }
            }
            else {
                offNameArray.append(cell.trackName.text!)
            }
            if (values != nil) {
                offNameArray = values!
            }
            userDefaults.set(offNameArray, forKey: "name")
            let price = Double(cell.price.text!)
            offPriceArray.append(price!)
            userDefaults.set(offPriceArray, forKey: "price")
            
            offGenreArray.append(cell.genre.text!)
            userDefaults.set(offGenreArray, forKey: "genre")
        }
        else {
            likes[sender.tag] = "like"
            sender.setImage(UIImage(named: "like2"), for: .normal)
            sender.backgroundColor = .clear
            if let idx = selectedIndex.firstIndex(where: { $0 == sender.tag }) {
                selectedIndex.remove(at: idx)
            }
            let removeNmae = cell.trackName.text
            let genre = cell.genre.text
            while offNameArray.contains(removeNmae!) {
                if let itemToRemoveIndex = offNameArray.firstIndex(of: removeNmae!) {
                    offNameArray.remove(at: itemToRemoveIndex)
                    userDefaults.set(offNameArray, forKey: "name")
                }
            }
            if let idx = offPriceArray.firstIndex(where: { Int($0) == sender.tag }) {
                selectedIndex.remove(at: idx)
            }
            while offGenreArray.contains(genre!) {
                if let itemToRemoveIndex = offGenreArray.firstIndex(of: genre!) {
                    offGenreArray.remove(at: itemToRemoveIndex)
                    userDefaults.set(offGenreArray, forKey: "genre")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
          as? ListTableViewCell else { return }
        let description = viewModel?.description[indexPath.row]
            let vc = ListDetailViewController.create(viewModel: ListDetailsViewModel(description: description!, name: cell.trackName.text!, isLiked: true))
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(true, animated: true)
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchArray = (viewModel?.nameArray.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() })!
               searching = true
               tableView.reloadData()
    }
    
}
