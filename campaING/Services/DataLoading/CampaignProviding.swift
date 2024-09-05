//
//  CampaignProviding.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//

protocol CampaignProviding {
    func campaignsFor(_ channel: CampaignChannel) -> [Campaign]
}
