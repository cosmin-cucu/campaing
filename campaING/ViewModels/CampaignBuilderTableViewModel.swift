//
//  CampaignBuilderTableViewModel.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

class CampaignBuilderTableViewModel: NSObject {
    let step: CampaignBuilderStep
    let service: CampaignBuilding
    
    init(builderService: CampaignBuilding, step: CampaignBuilderStep = .chooseTargetingSpecifics) {
        self.service = builderService
        self.step = step
    }
    
    var numberOfFilters: Int {
        return service.specifics.count
    }
    
    func customizeCell(_ cell: TargetingSpecificCell, for row: Int) {
        let isCellSelected = service.selectedSpecifics.contains(where: { $0.specificIdentifier == service.specifics[row].specificIdentifier })
        cell.customizeWith(service.specifics[row], isSelected: isCellSelected)
    }
}

// MARK: UITableViewDataSource
extension CampaignBuilderTableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfFilters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let targetingSpecificCell = tableView.dequeueReusableCell(withIdentifier: "TargetingSpecificCell", for: indexPath) as? TargetingSpecificCell else {
            return UITableViewCell()
        }
        customizeCell(targetingSpecificCell, for: indexPath.row)
        return targetingSpecificCell
    }
}
