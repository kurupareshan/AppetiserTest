//
//  ListDetailsViewModel.swift
//  Appetiser
//
//  Created by kurupareshan pathmanathan on 5/30/22.
//

import Foundation

class ListDetailsViewModel {
    var description = String()
    var name = String()
    var isLiked: Bool = false
    init(description : String, name: String, isLiked: Bool) {
        self.description = description
        self.name = name
        self.isLiked = isLiked
    }
}
