//
//  ListViewModel.swift
//  Appetiser
//
//  Created by kurupareshan pathmanathan on 5/30/22.
//

import Foundation

class ListViewModel {

    var array = NSArray()
    var nameArray = [String]()
    var priceArray = [Double]()
    var genreArray = [String]()
    var imageURL = [String]()
    var description = [String]()
    var isOffline: Bool = false
    
    func getData() {
        let url = URL(string: "https://itunes.apple.com/search?term=star&country=au&media=movie&all")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
                   let person = jsonResult["results"] as? [Any] {
                    self.array = person as NSArray
                    for d in self.array {
                        let x = (d as AnyObject).object(forKey: "trackName")
                        self.nameArray.append(x as! String)
                    }
                    for d in self.array {
                        let x = (d as AnyObject).object(forKey: "kind")
                        self.genreArray.append(x as! String)
                    }
                    for d in self.array {
                        let x = (d as AnyObject).object(forKey: "collectionPrice")
                        self.priceArray.append(x as! Double)
                    }
                    for d in self.array {
                        let x = (d as AnyObject).object(forKey: "artworkUrl60")
                        self.imageURL.append(x as! String)
                    }
                    for d in self.array {
                        let x = (d as AnyObject).object(forKey: "longDescription")
                        self.description.append(x as! String)
                    }
                }
            } catch let error as NSError {
                if  error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                    self.isOffline = true
                }
            }
        }).resume()
    }
}
