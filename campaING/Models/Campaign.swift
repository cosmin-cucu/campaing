//
//  Campaign.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import UIKit

struct Campaign: Codable, Hashable, Equatable {
    let price: Int
    let optimizations: Int?
    let features: [String]
}

extension Campaign: ChooseCampaignCellCustomizing {
    func customize(_ cell: ChooseCampaignCollectionViewCell) {
        cell.priceLabel.text = "\(price) EUR"
        if let optimizations {
            cell.optimizationsLabel.text = "\(optimizations) optimizations"
        } else {
            cell.optimizationsLabel.isHidden = true
        }
        features.forEach { cell.featuresStackView.addArrangedSubview(createFeatureLabel($0)) }
    }
    
    func createFeatureLabel(_ feature: String) -> UILabel {
        let label = UILabel()
        label.text = feature
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }
}
