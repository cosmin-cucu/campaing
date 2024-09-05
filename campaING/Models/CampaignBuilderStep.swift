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
    
    var dataType: any CampaignFilteringUIRepresentableType.Type {
        switch self {
        case .chooseTargetingSpecifics: return TargetingSpecific.self
        case .chooseCampaignChannel: return CampaignChannel.self
        case .chooseCampaign: return Campaign.self
        case .summary: fatalError("No data type for \(self)")
        }
    }
    
    var filterViewControllerConfiguration: CampaignFilterViewControllerConfigurating {
        return CampaignFilterViewControllerConfiguration(self)
    }
}

protocol CampaignFilterViewControllerConfigurating {
    var title: String { get }
    var rightBarButtonTitle: String { get }
    var shouldShowLeftBarbutton: Bool { get }
    var shouldShowRightBarbutton: Bool { get }
}


struct CampaignFilterViewControllerConfiguration: CampaignFilterViewControllerConfigurating {
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
