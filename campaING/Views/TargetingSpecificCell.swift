//
//  TargetingSpecificCell.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

final class TargetingSpecificCell: UITableViewCell {
    @IBOutlet weak var specificNameLabel: UILabel!
    
    func customizeWith(_ specific: TargetingSpecific, isSelected: Bool) {
        specificNameLabel.text = specific.specificIdentifier
        backgroundColor = isSelected ? .systemGray5 : .clear
    }
}
