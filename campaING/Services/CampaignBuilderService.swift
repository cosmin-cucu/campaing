//
//  CampaignBuilderService.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import Foundation

protocol CampaignBuilding {
    var availableSpecifics: [TargetingSpecific] { get }
    var selectedSpecifics: [TargetingSpecific] { get }
    var selectedCampaignChannel: CampaignChannel? { get }
    var selectedCampaign: Campaign? { get }
    func didSelectOption(_ option: any CampaignBuilderFilteringDataType)
}

protocol CampaignBuilderDataProviding {
    func campaignsFor(_ channel: CampaignChannel) -> [Campaign]
    func dataFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType]
    func selectedOptionsFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType]
}

extension CampaignBuilderDataProviding where Self: CampaignBuilding {
    func dataFor(_ step: CampaignBuilderStep) -> [any CampaignBuilderFilteringDataType] {
        switch step {
        case .chooseTargetingSpecifics: return availableSpecifics
        case .chooseCampaignChannel: return selectedSpecifics.map(\.campaignChannels).flatMap { $0 }.uniqued()
        case .chooseCampaign:
            guard let selectedCampaignChannel else { return [] }
            return campaignsFor(selectedCampaignChannel)
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

protocol CampaignBuilderServiceProviding: CampaignBuilding, CampaignBuilderDataProviding {}

class CampaignBuilderService: CampaignBuilderServiceProviding {
    var selectedCampaignChannel: CampaignChannel?
    var selectedCampaign: Campaign?
    private let targetingSpecificsProvider: TargetingSpecificsProviding
    private(set) var selectedSpecifics = [TargetingSpecific]()
    private(set) var availableSpecifics: [TargetingSpecific]
    
    init(targetingSpecificsProvider: TargetingSpecificsProviding) {
        self.targetingSpecificsProvider = targetingSpecificsProvider
        self.availableSpecifics = targetingSpecificsProvider.targetingSpecifics
    }
    
    func didSelectOption(_ option: any CampaignBuilderFilteringDataType) {
        switch type(of: option) {
        case is TargetingSpecific.Type:
            updateSpecificsWith(option as! TargetingSpecific)
        case is CampaignChannel.Type:
            selectedCampaignChannel = option as? CampaignChannel
        case is Campaign.Type:
            selectedCampaign = option as? Campaign
        default:
            break
        }
    }
    
    func campaignsFor(_ channel: CampaignChannel) -> [Campaign] {
        return []
    }
    
    private func updateSpecificsWith(_ selectedSpecific: TargetingSpecific) {
        if selectedSpecifics.contains(selectedSpecific) {
            selectedSpecifics = selectedSpecifics.filter { $0 != selectedSpecific }
        } else {
            selectedSpecifics.append(selectedSpecific)
        }
        availableSpecifics = targetingSpecificsProvider.availableSpecificsFor(selectedSpecifics)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
