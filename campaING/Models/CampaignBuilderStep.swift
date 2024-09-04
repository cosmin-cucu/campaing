//
//  CampaignBuilderStep.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//

enum CampaignBuilderStep {
    case chooseTargetingSpecifics
    case chooseCampaignChannel
    case chooseCampaign
    case summary
    
    var title: String {
        switch self {
        case .chooseTargetingSpecifics: return "Targeting Specifics"
        case .chooseCampaignChannel: return "Channels"
        case .chooseCampaign: return "Campaign"
        case .summary: return "Summary"
        }
    }
    
    var rightBarButtonTitle: String? {
        if next != nil {
            return "Next"
        } else {
            return "Done"
        }
    }
    
    var previous: CampaignBuilderStep? {
        switch self {
        case .chooseTargetingSpecifics: return nil
        case .chooseCampaignChannel: return .chooseTargetingSpecifics
        case .chooseCampaign: return .chooseCampaignChannel
        case .summary: return .chooseCampaign
        }
    }
    
    var next: CampaignBuilderStep? {
        switch self {
        case .chooseTargetingSpecifics: return .chooseCampaignChannel
        case .chooseCampaignChannel: return .chooseCampaign
        case .chooseCampaign: return .summary
        case .summary: return nil
        }
    }
}
