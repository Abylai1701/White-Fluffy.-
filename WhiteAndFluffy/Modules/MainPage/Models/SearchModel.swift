//
//  SearchModel.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 30.03.2025.
//

import Foundation

struct UnsplashSearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashPhoto]
}
