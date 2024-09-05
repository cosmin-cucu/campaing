//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct Campaign: Codable, Hashable, Equatable, CampaignBuildingRepresentableType {
    var name: String
    let details: [String]
}
