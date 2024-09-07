//
//  FakeCampaignBuilderServiceProvider.swift
//  campaING
//
//  Created by Cosmin Cucu on 7/9/24.
//

@testable import campaING

struct FakeCampaignBuilderServiceProvider: CampaignBuilderServiceProviding {
    var availableSpecifics: [TargetingSpecific] {
        return []
    }
    
    var selectedSpecifics: [TargetingSpecific] {
        return []
    }
    
    var selectedCampaignChannel: CampaignChannel? = CampaignChannel(identifier: "Fake Channel", campaigns: [Campaign(price: 25, listings: nil, optimizations: nil, features: [])])
    
    var selectedCampaigns: [CampaignChannel: Campaign] = [:]
    
    func didSelectOption(_ option: any CampaignBuildingDataType) {
        // NO-OP
    }
}
