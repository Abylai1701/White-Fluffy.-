//
//  MainPageModel.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 30.03.2025.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let urls: PhotoURLs
    let user: User
    let created_at: String
    let location: PhotoLocation?
    let downloads: Int?
    let description: String?
    let alt_description: String?
    let likes: Int
}

struct PhotoLocation: Codable {
    let name: String?
    let city: String?
    let country: String?
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let name: String?
    let username: String
    let links: UserLinks
    let profile_image: ProfileImage?
}

struct UserLinks: Codable {
    let html: String
}

struct ProfileImage: Codable {
    let large: String?
}
