//
//  ElementAPIClient.swift
//  collection-views
//
//  Created by David Rifkin on 9/26/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct CountryAPIClient {
    
    // MARK: - Static Properties
    
    static let manager = CountryAPIClient()
    
    // MARK: - Instance Methods
    
    
    func getCountry(completionHandler: @escaping (Result<[Country], AppError>) -> ())  {
        NetworkHelper.manager.performDataTask(withUrl: countryURL, andMethod: .get) { (results) in
            switch results {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let countryInfo = try Country.decodeCountryFromData(from: data)
                    completionHandler(.success(countryInfo))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
    }
    
    
    // MARK: - Private Properties and Initializers
    private var countryURL: URL {
        guard let url = URL(string: "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements") else {
            fatalError("Error: Invalid URL")
        }
        return url
    }
    
    private init() {}
}
