//
//  CampaignBuilderTableViewModel.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import Foundation

struct CampaignBuilderTableViewModel {
    let service: CampaignBuilderService
    
    init(builderService: CampaignBuilderService) {
        self.service = builderService
    }
    
    var numberOfFilters: Int {
        return service.filters.count
    }
    
    func customizeCell(_ cell: TargetingSpecificCell, for row: Int) {
        let isCellSelected = service.selectedSpecifics.contains(where: { $0.specificIdentifier == service.filters[row].specificIdentifier })
        cell.customizeWith(service.filters[row], isSelected: isCellSelected)
    }
}
