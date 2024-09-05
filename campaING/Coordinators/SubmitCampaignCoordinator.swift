//
//  SubmitCampaignCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit
import MessageUI

class SubmitCampaignCoordinator: NSObject, ChildCoordinator {
    weak var delegate: ChildCoordinatorDelegate?
    let service: CampaignSubmittingService
    var navigationController: UINavigationController
    let campaigns: [CampaignChannel: Campaign]
    
    init(delegate: ChildCoordinatorDelegate? = nil, service: CampaignSubmittingService, campaigns: [CampaignChannel: Campaign], navigationController: UINavigationController) {
        self.campaigns = campaigns
        self.delegate = delegate
        self.service = service
        self.navigationController = navigationController
    }
    
    func start() {
        if MFMailComposeViewController.canSendMail() {
            presentEmail()
        } else {
            delegate?.coordinatorFinished(self)
        }
    }
    
    func presentEmail() {
        let emailViewController = newEmailViewController()
        navigationController.present(emailViewController, animated: true)
    }
    
    func newEmailViewController() -> MFMailComposeViewController {
        let emailViewController = MFMailComposeViewController()
        emailViewController.mailComposeDelegate = self
        emailViewController.setToRecipients(["bogus@bogus.com"])
        emailViewController.setMessageBody(campaigns.toHTML(), isHTML: true)
        return emailViewController
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        // NO-OP
    }    
}

extension SubmitCampaignCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        delegate?.coordinatorFinished(self)
    }
}

