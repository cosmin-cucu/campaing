//
//  FakeCampaignProvider.swift
//  campaING
//
//  Created by Cosmin Cucu on 7/9/24.
//

@testable import campaING

struct FakeCampaignProvider : CampaignProviding {
    func campaignsFor(_ channelIdentifier: String) -> [Campaign] {
        [
            Campaign(price: 100, listings: "1", optimizations: 2, features: ["Feature", "Other Feature"]),
                     Campaign(price: 75, listings: "1-2", optimizations: nil, features: ["Feature"])
        ]
    }
}
