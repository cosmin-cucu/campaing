//
//  TargetingSpecificCell.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

final class CampaignBuildingFilterCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

protocol CampaignBuildingFilterCellCustomizing {
    var name: String { get }
    func customize(_ cell: CampaignBuildingFilterCell, isSelected: Bool)
}

extension CampaignBuildingFilterCellCustomizing {
    func customize(_ cell: CampaignBuildingFilterCell, isSelected: Bool) {
        cell.nameLabel.text = name
        cell.backgroundColor = isSelected ? .systemGray5 : .clear
    }
}
