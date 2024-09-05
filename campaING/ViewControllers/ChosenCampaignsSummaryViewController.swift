//
//  ChosenCampaignsSummaryViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

protocol StackViewRepresentable {
    func newStackViewSubviews() -> [UIView]
}

extension CampaignChannel: StackViewRepresentable {
    func newStackViewSubviews() -> [UIView] {
        let channelNameLabel = UILabel()
        channelNameLabel.text = name
        channelNameLabel.font = .preferredFont(forTextStyle: .title1)
        return [channelNameLabel]
    }
}

extension Campaign: StackViewRepresentable {
    func newStackViewSubviews() -> [UIView] {
        let detailsStackView = UIStackView()
        detailsStackView.axis = .vertical
        
        let priceLabel = UILabel()
        priceLabel.text = "\(price) EUR"
        priceLabel.font = .preferredFont(forTextStyle: .title1)
        detailsStackView.addArrangedSubview(priceLabel)
        
        if let listings = listings {
            let listingsLabel = UILabel()
            listingsLabel.text = listings + " listings"
            listingsLabel.font = .preferredFont(forTextStyle: .headline)
            detailsStackView.addArrangedSubview(listingsLabel)
        }
        
        if let optimizations = optimizations {
            let optimizationsLabel = UILabel()
            optimizationsLabel.text = "\(optimizations) optimizations"
            optimizationsLabel.font = .preferredFont(forTextStyle: .subheadline)
            detailsStackView.addArrangedSubview(optimizationsLabel)
        }
        
        let featuresStack = UIStackView()
        features.forEach {
            let featureLabel = UILabel()
            featureLabel.text = $0
            featuresStack.addArrangedSubview(featureLabel)
        }
        
        return [detailsStackView, featuresStack]
    }
}

class ChosenCampaignsSummaryViewController: UIViewController {
    weak var delegate: ChosenCampaignsSummaryViewControllerDelegate?
    @IBOutlet weak var campaignsStackView: UIStackView!
    let campaigns: [CampaignChannel: Campaign]
    
    
    required init?(coder: NSCoder) {
        self.campaigns = [:]
        super.init(coder: coder)
    }
    
    init?(coder: NSCoder, campaigns: [CampaignChannel: Campaign], delegate: ChosenCampaignsSummaryViewControllerDelegate? = nil) {
        self.campaigns = campaigns
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        campaigns.forEach(addNewStack)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.summaryViewControllerWasDismissed()
    }
    
    private func addNewStack(channel: CampaignChannel, campaign: Campaign) {
        let channelSubviews = channel.newStackViewSubviews()
        let campaignSubviews = campaign.newStackViewSubviews()
        let detailsStack = UIStackView(arrangedSubviews: channelSubviews + [campaignSubviews.first!])
        detailsStack.axis = .vertical
        
        let featuresStack = UIStackView(arrangedSubviews: [campaignSubviews.last!])
        let stack = UIStackView(arrangedSubviews: [detailsStack, featuresStack])
        
        campaignsStackView.addArrangedSubview(stack)
    }
    
    @IBAction func didPressSubmit(_ sender: Any) {
        delegate?.submitCampaigns()
    }
    
    static func instantiate(_ delegate: ChosenCampaignsSummaryViewControllerDelegate? = nil, _ campaigns: [CampaignChannel: Campaign]) -> ChosenCampaignsSummaryViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(identifier: "ChosenCampaignsSummaryViewController", creator: { coder in
            let viewController = ChosenCampaignsSummaryViewController(coder: coder, campaigns: campaigns, delegate: delegate)
            return viewController
        })
    }
}

protocol ChosenCampaignsSummaryViewControllerDelegate: AnyObject {
    func summaryViewControllerWasDismissed()
    func submitCampaigns()
}
