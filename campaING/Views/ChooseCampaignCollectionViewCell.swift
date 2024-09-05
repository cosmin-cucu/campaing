//
//  ChooseCampaignCellCustomizing.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

protocol ChooseCampaignCellCustomizing {
    func customize(_ cell: ChooseCampaignCollectionViewCell)
}

class ChooseCampaignCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var listingsLabel: UILabel!
    @IBOutlet weak var optimizationsLabel: UILabel!
    @IBOutlet weak var featuresStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgroundViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featuresStackView.arrangedSubviews.forEach {
            featuresStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func setupBackgroundViews () {
        let newBackgroundView = UIView(frame: bounds)
        newBackgroundView.backgroundColor = .white
        self.backgroundView = newBackgroundView
        let newSelectedBackgroundView = UIView(frame: bounds)
        newSelectedBackgroundView.backgroundColor = .systemGray4
        self.selectedBackgroundView = newSelectedBackgroundView
    }
}


extension Campaign: ChooseCampaignCellCustomizing {
    func customize(_ cell: ChooseCampaignCollectionViewCell) {
        cell.priceLabel.text = "\(price) EUR"
        if let optimizations {
            cell.optimizationsLabel.text = "\(optimizations) optimizations"
        } else {
            cell.optimizationsLabel.isHidden = true
        }
        if let listings {
            cell.listingsLabel.text = listings + " listings"
        } else {
            cell.listingsLabel.isHidden = true
        }
        
        features.forEach { feature in
            let newLabel = createFeatureLabel(feature)
            cell.featuresStackView.addArrangedSubview(newLabel)
        }
    }
    
    func createFeatureLabel(_ feature: String) -> UILabel {
        let label = UILabel()
        label.text = feature
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }
}
