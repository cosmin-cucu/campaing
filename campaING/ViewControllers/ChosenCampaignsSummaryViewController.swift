//
//  ChosenCampaignsSummaryViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

class ChosenCampaignsSummaryViewController: UIViewController {
    weak var delegate: ChosenCampaignsSummaryViewControllerDelegate?
    
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
            let viewController = ChosenCampaignsSummaryViewController(coder: coder)
            viewController?.delegate = delegate
            return viewController
        })
    }
}

protocol ChosenCampaignsSummaryViewControllerDelegate: AnyObject {
    func summaryViewControllerWasDismissed()
    func submitCampaigns()
}
