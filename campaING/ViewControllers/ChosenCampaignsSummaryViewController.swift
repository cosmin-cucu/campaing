//
//  ChosenCampaignsSummaryViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit
import WebKit

protocol ChosenCampaignsSummaryViewControllerDelegate: AnyObject {
    func summaryViewControllerWasDismissed()
    func submitCampaigns()
}

class ChosenCampaignsSummaryViewController: UIViewController {
    weak var delegate: ChosenCampaignsSummaryViewControllerDelegate?
    private let campaigns: [CampaignChannel: Campaign]
    @IBOutlet weak var summaryWebview: WKWebView!
    
    required init?(coder: NSCoder) {
        self.campaigns = [:]
        super.init(coder: coder)
    }
    
    init?(coder: NSCoder, campaigns: [CampaignChannel: Campaign], delegate: ChosenCampaignsSummaryViewControllerDelegate? = nil) {
        self.delegate = delegate
        self.campaigns = campaigns
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryWebview.loadHTMLString(campaigns.toHTML(), baseURL: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.summaryViewControllerWasDismissed()
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
