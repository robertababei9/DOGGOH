//
//  NetworkWithAlamo.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 22/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoints {
    case breedImage(String)
}

extension Endpoints {
    var endpoint: String {
        switch self {
        case .breedImage(let breedName):
            return "breed/\(breedName)/images/random"
        }
    }
}

class NetworkWithAlamo {
    
    let baseUrl: URL
    
    static let shared = NetworkWithAlamo(baseUrl: URL(string: "https://dog.ceo/api/")!)
    
    private init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func getImageByBreed(breedName: String, completion: @escaping (Result<DogImageURL, Error>) -> Void) {
        AF.request("\(baseUrl)\(Endpoints.breedImage(breedName).endpoint)").response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success( _ ):
                if let data = response.data {
                    if let imageObject = try? JSONDecoder().decode(DogImageURL.self, from: data) {
                        completion(.success(imageObject))
                    }
                    else {
                        print("Something went wrong at decoding image")
                    }
                }
            }
        }
    }
}
