//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct Campaign: Codable {
    let id: Int
    let channel: CampaignChannel
    let details: [String]
}
