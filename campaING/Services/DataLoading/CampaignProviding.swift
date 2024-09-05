//
//  CampaignProviding.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import Foundation

protocol CampaignProviding {
    func campaignsFor(_ channelIdentifier: String) -> [Campaign]
}

struct LocalJSONCampaignLoader: CampaignProviding {
    private let json = "Campaigns.json"
    private var channels: [CampaignChannel] {
        do {
            let data = try JSONReader.read(json)
            let decoder = JSONDecoder()
            return try decoder.decode([CampaignChannel].self, from: data)
        } catch let error {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    
    func campaignsFor(_ channelIdentifier: String) -> [Campaign] {
        return channels
            .first(where: { $0.identifier == channelIdentifier})
            .flatMap(\.campaigns) ?? []
    }
}

