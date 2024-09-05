//
//  CampaignFilterViewControllerConfigurating.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import Foundation

protocol ViewConfigurating { }

protocol BuilderTableViewControllerConfigurating: ViewConfigurating {
    var title: String { get }
    var rightBarButtonTitle: String { get }
    var shouldShowLeftBarbutton: Bool { get }
    var shouldShowRightBarbutton: Bool { get }
}

struct BuilderTableViewConfiguration: BuilderTableViewControllerConfigurating {
    let title: String
    let rightBarButtonTitle: String
    let shouldShowLeftBarbutton: Bool
    let shouldShowRightBarbutton: Bool
    
    init(_ step: CampaignBuilderStep) {
        self.title = step.title
        self.shouldShowLeftBarbutton = step.previous != nil
        self.rightBarButtonTitle = step.rightBarButtonTitle
        self.shouldShowRightBarbutton = step != .chooseCampaignChannel
    }
}

fileprivate extension CampaignBuilderStep {
    var title: String {
        switch self {
        case .chooseTargetingSpecifics: return "Targeting Specifics"
        case .chooseCampaignChannel: return "Channels"
        case .chooseCampaign: return "Campaign"
        case .summary: return "Summary"
        }
    }
    
    var rightBarButtonTitle: String {
        if next != nil {
            return "Next"
        } else {
            return "Done"
        }
    }
}
