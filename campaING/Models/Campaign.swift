//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct Campaign: Codable {
    let channel: CampaignChannel
    let details: [String]
}
