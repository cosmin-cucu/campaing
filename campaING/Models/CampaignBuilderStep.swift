//
//  CampaignBuilderStep.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//

protocol CampaignBuildingDataType: Equatable, Hashable, Codable { }
protocol CampaignBuilderFilteringDataType: CampaignBuildingDataType { }

enum CampaignBuilderStep {
    case chooseTargetingSpecifics
    case chooseCampaignChannel
    case chooseCampaign
    case summary
    
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
    
    var dataType: (any BuilderTableViewRepresentableType.Type)? {
        switch self {
        case .chooseTargetingSpecifics: return TargetingSpecific.self
        case .chooseCampaignChannel: return CampaignChannel.self
        case .chooseCampaign, .summary: return nil
        }
    }
    
    var viewControllerConfiguration: ViewConfigurating {
        return BuilderTableViewConfiguration(self)
    }
}
