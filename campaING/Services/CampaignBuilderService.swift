//
//  CampaignBuilderService.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import Foundation

protocol CampaignBuilding {
    var specifics: [TargetingSpecific] { get }
    var selectedSpecifics: [TargetingSpecific] { get }
    func didSelectSpecific(_ indexPath: IndexPath)
}

class CampaignBuilderService: CampaignBuilding {
    private let targetingSpecificsProvider: TargetingSpecificsProviding
    private(set) var selectedSpecifics = [TargetingSpecific]()
    var specifics: [TargetingSpecific]
    
    init(targetingSpecificsProvider: TargetingSpecificsProviding) {
        self.targetingSpecificsProvider = targetingSpecificsProvider
        self.specifics = targetingSpecificsProvider.targetingSpecifics
    }
    
    func didSelectSpecific(_ indexPath: IndexPath) {
        let selectedSpecific = specifics[indexPath.row]
        if selectedSpecifics.contains(where: { $0 == selectedSpecific }) {
            selectedSpecifics = selectedSpecifics.filter { $0 != selectedSpecific }
        } else {
            selectedSpecifics.append(specifics[indexPath.row])
        }
        specifics = targetingSpecificsProvider.availableSpecificsFor(selectedSpecifics)
    }
}

