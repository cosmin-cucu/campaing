//
//  CampaignSubmittingService.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import Foundation

protocol CampaignSubmittingService {
    func submit(_ campaigns: [CampaignChannel: Campaign])
}


struct CampaignSubmitter: CampaignSubmittingService {
    func submit(_ campaigns: [CampaignChannel: Campaign]) {
        
    }
}
