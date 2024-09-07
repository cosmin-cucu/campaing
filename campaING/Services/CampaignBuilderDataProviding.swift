//
//  CampaignBuilderDataProviding.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//

import UIKit

enum CampaignBuilderDataReadingError: Error {
    case stepShouldReadNoData
}

protocol CampaignBuilderDataProviding {
    func dataFor(_ step: CampaignBuilderStep) throws -> [any CampaignBuilderFilteringDataType]
    func selectedOptionsFor(_ step: CampaignBuilderStep) throws -> [any CampaignBuilderFilteringDataType]
}

extension CampaignBuilderDataProviding where Self: CampaignBuilding {
    func dataFor(_ step: CampaignBuilderStep) throws -> [any CampaignBuilderFilteringDataType] {
        switch step {
        case .chooseTargetingSpecifics: return availableSpecifics
        case .chooseCampaignChannel:
            return selectedSpecifics.map(\.campaignChannels).flatMap { $0 }.uniqued().compactMap(CampaignChannel.init)
        case .chooseCampaign:
            throw CampaignBuilderDataReadingError.stepShouldReadNoData
        case .summary: throw CampaignBuilderDataReadingError.stepShouldReadNoData
        }
    }
    
    func selectedOptionsFor(_ step: CampaignBuilderStep) throws -> [any CampaignBuilderFilteringDataType] {
        switch step {
        case .chooseTargetingSpecifics: return selectedSpecifics
        case .chooseCampaignChannel:
            guard let selectedCampaignChannel else {
                return []
            }
            return [selectedCampaignChannel]
        case .chooseCampaign, .summary: throw CampaignBuilderDataReadingError.stepShouldReadNoData
        }
    }
}
