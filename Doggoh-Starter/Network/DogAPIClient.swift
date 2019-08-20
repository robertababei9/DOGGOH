//
//  DogAPIClient.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

enum DogAPI {
    case allDogs
    case randomBreedImage(String)
    case randomSubbreedImage(String, String)
    case randomDogImages(Int)
    case randomBreedMultipleImages(String, Int)
}

extension DogAPI {
    var endpoint: String {
        switch self {
        case .allDogs:
            return "breeds/list/all"
        case .randomBreedImage(let breedName):
            return "breed/\(breedName)/images/random"
        case .randomSubbreedImage(let breedName, let subBreedName):
            return "breed/\(breedName)/\(subBreedName)/images/random"
        case .randomDogImages(let nr):
            return "breeds/image/random/\(nr)"
        case .randomBreedMultipleImages(let breedName, let nr):
            return "breed/\(breedName)/images/random/\(nr)"
        }
    }
}

class DogAPIClient {
    var baseURL: URL
    
    static let sharedInstance = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)

    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getAllDogs(_ completion: @escaping ((Result<[Dog], NetworkError>)-> Void)) {
        var dogsFromURL = [Dog]()
        let url = URL(string: "\(baseURL)\(DogAPI.allDogs.endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                    allDogs.message.forEach({
                        dogsFromURL.append(Dog(dogRace: $0.key, dogs: $0.value))
                    })
                    completion(.success(dogsFromURL))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getMultipleRandomImages(_ completion: @escaping ((Result<MultipleDogImageURL,NetworkError>) -> Void)) {
        let url = URL(string: "\(baseURL)\(DogAPI.randomDogImages(30).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode(MultipleDogImageURL.self, from: data)
                    completion(.success(images))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImagesByBreed(breedName: String, nrOfImages: Int, _ completion: @escaping ((Result<MultipleDogImageURL, NetworkError>)-> Void)) {
        let url = URL(string: "\(baseURL)\(DogAPI.randomBreedMultipleImages(breedName, nrOfImages).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode(MultipleDogImageURL.self, from: data)
                    completion(.success(images))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }

    }
    
    func getImageByBreed(breedName: String, _ completion: @escaping ((Result<DogImageURL, NetworkError>) -> Void)) {
        let url = URL(string: "\(baseURL)\(DogAPI.randomBreedImage(breedName).endpoint)")!
        let networkmanager = NetworkManager(url: url)
        networkmanager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImageURL.self, from: data)
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getImageBySubBreed(breedName: String, subBreedName: String, _ completion: @escaping ((Result<DogImageURL, NetworkError>)-> Void)) {
        let url = URL(string: "\(baseURL)\(DogAPI.randomSubbreedImage(breedName, subBreedName).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImageURL.self, from: data)
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
}
