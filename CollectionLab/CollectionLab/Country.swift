//
//  Country.swift
//  CollectionLab
//
//  Created by Kimball Yang on 9/26/19.
//  Copyright © 2019 Kimball Yang. All rights reserved.
//

import Foundation
import UIKit

struct Country: Codable {
    let name: String
    let alpha2Code: String
    let capital: String
    let population: Int
    
    static func decodeCountryFromData(from jsonData: Data) throws -> [Country] {
        let response = try JSONDecoder().decode([Country].self, from: jsonData)
        return response
    }
    
}
