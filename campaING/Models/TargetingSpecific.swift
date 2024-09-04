//
//  TargetingSpecific.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

struct TargetingSpecific: Codable, Equatable {
    let specificIdentifier: String
    let campaignChannels: [CampaignChannel]
}
