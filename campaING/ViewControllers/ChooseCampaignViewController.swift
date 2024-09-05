//
//  ChooseCampaignViewControllerDelegate.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

protocol ChooseCampaignViewControllerDelegate: AnyObject {
    func finishedSelection(_ campaign: Campaign?)
}

class ChooseCampaignViewController: UICollectionViewController {
    weak var delegate: ChooseCampaignViewControllerDelegate?
    var campaigns: [Campaign]
    var chosenCampaign: Campaign?
    
    static func instantiate(_ channel: CampaignChannel, campaignProvider: CampaignProviding) -> ChooseCampaignViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(identifier: "ChooseCampaignViewController", creator: { coder in
            ChooseCampaignViewController(coder: coder, channel: channel, campaignProvider: campaignProvider)
        })
    }
    
    init?(coder: NSCoder, channel: CampaignChannel, campaignProvider: CampaignProviding) {
        self.campaigns = campaignProvider.campaignsFor(channel.identifier)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init? not implemented!")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.finishedSelection(chosenCampaign)
        super.viewDidDisappear(animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCampaignCollectionViewCell", for: indexPath) as? ChooseCampaignCollectionViewCell else {
            return UICollectionViewCell()
        }
        campaigns[indexPath.row].customize(cell)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCampaign = campaigns[indexPath.row]
        print(chosenCampaign)
    }
    
}

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
        
        let redView = UIView(frame: bounds)
        redView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        self.backgroundView = redView
        
        
        let blueView = UIView(frame: bounds)
        blueView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
        self.selectedBackgroundView = blueView
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = superview?.frame.size
        
        var frame = layoutAttributes.frame
        frame.size = size ?? .zero
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}
