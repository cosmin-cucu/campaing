//
//  TargetingSpecific.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

struct TargetingSpecific: Codable, Equatable, CampaignFilteringUIRepresentableType {
    let name: String
    let campaignChannels: [CampaignChannel]
}
