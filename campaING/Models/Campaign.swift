//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct Campaign: CampaignBuildingDataType {
    let price: Int
    let listings: String?
    let optimizations: Int?
    let features: [String]
    
    init(price: Int, listings: String?, optimizations: Int?, features: [String]) {
        self.price = price
        self.listings = listings
        self.optimizations = optimizations
        self.features = features
    }
}
