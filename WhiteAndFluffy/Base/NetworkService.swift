//
//  NetworkService.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 30.03.2025.
//

import Foundation
import Alamofire

class UnsplashNetworkService {
    private let accessKey = "GwbjueGD7EEsbgQZ5rNKe4bEcXbANiQ-_BKJdjTxT2E"
    private let baseURL = "https://api.unsplash.com"
    
    func fetchRandomPhotos() async throws -> [UnsplashPhoto] {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: Parameters = [
                "client_id": accessKey,
                "count": 20
            ]
            AF.request("\(baseURL)/photos/random", parameters: parameters)
                .validate()
                .responseDecodable(of: [UnsplashPhoto].self) { response in
                    switch response.result {
                    case .success(let photos):
                        continuation.resume(returning: photos)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func searchPhotos(query: String) async throws -> [UnsplashPhoto] {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: Parameters = [
                "client_id": accessKey,
                "query": query
            ]
            
            AF.request("\(baseURL)/search/photos", parameters: parameters)
                .validate()
                .responseDecodable(of: UnsplashSearchResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        continuation.resume(returning: response.results)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
