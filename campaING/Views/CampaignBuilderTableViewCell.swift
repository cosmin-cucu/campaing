//
//  TargetingSpecificCell.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

final class CampaignBuilderTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

protocol CampaignBuilderCellCustomizing {
    var name: String { get }
    func customize(_ cell: CampaignBuilderTableViewCell, isSelected: Bool)
}

extension CampaignBuilderCellCustomizing {
    func customize(_ cell: CampaignBuilderTableViewCell, isSelected: Bool) {
        cell.nameLabel.text = name
        cell.backgroundColor = isSelected ? .systemGray5 : .clear
    }
}
