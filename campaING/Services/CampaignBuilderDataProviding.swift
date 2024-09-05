//
//  CampaignBuilderDataProviding.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//

import UIKit

protocol CampaignBuilderDataProviding {
    func dataFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType]
    func selectedOptionsFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType]
}

extension CampaignBuilderDataProviding where Self: CampaignBuilding {
    func dataFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType] {
        switch step {
        case .chooseTargetingSpecifics: return availableSpecifics
        case .chooseCampaignChannel:
            return selectedSpecifics.map(\.campaignChannels).flatMap { $0 }.uniqued().compactMap(CampaignChannel.init)
        case .chooseCampaign:
            fatalError("Summary has no data to provide. The campaign is built")
        case .summary: fatalError("Summary has no data to provide. The campaign is built")
        }
    }
    
    func selectedOptionsFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType] {
        switch step {
        case .chooseTargetingSpecifics: return selectedSpecifics
        case .chooseCampaignChannel:
            guard let selectedCampaignChannel else {
                return []
            }
            return [selectedCampaignChannel]
        case .chooseCampaign, .summary: fatalError("Summary has no data to provide. The campaign is built")
        }
    }
}
