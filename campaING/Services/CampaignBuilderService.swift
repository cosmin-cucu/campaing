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
    var selectedCampaigns: [CampaignChannel: Campaign] { get }
    func didSelectOption(_ option: any CampaignBuildingDataType)
}

protocol CampaignBuilderServiceProviding: CampaignBuilding, CampaignBuilderDataProviding { }

class CampaignBuilderService: CampaignBuilderServiceProviding {
    var selectedCampaignChannel: CampaignChannel?
    var selectedCampaigns: [CampaignChannel: Campaign] = [:]
    private let targetingSpecificsProvider: TargetingSpecificsProviding
    private let campaignProvider: CampaignProviding
    private(set) var selectedSpecifics = [TargetingSpecific]()
    private(set) var availableSpecifics: [TargetingSpecific]
    
    init(targetingSpecificsProvider: TargetingSpecificsProviding, campaignProvider: CampaignProviding) {
        self.targetingSpecificsProvider = targetingSpecificsProvider
        self.campaignProvider = campaignProvider
        self.availableSpecifics = targetingSpecificsProvider.targetingSpecifics
    }
    
    func didSelectOption(_ option: any CampaignBuildingDataType) {
        switch type(of: option) {
        case is TargetingSpecific.Type:
            updateSpecificsWith(option as! TargetingSpecific)
        case is CampaignChannel.Type:
            selectedCampaignChannel = option as? CampaignChannel
        case is Campaign.Type:
            updateSelectedCampaingsWith(option as! Campaign)
        default:
            break
        }
    }
    
    private func updateSelectedCampaingsWith(_ campaign: Campaign) {
        guard let selectedCampaignChannel else { return }
        if let campaign = selectedCampaigns[selectedCampaignChannel],
           campaign == campaign {
            selectedCampaigns[selectedCampaignChannel] = nil
        } else {
            selectedCampaigns[selectedCampaignChannel] = campaign
        }
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
