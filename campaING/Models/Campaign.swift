//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct Campaign: Codable, Hashable, Equatable {
    var price: Int
    let features: [String]
}
 
