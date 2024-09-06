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
    var navigationController: UINavigationController
    let campaigns: [CampaignChannel: Campaign]
    
    init(delegate: ChildCoordinatorDelegate? = nil, campaigns: [CampaignChannel: Campaign], navigationController: UINavigationController) {
        self.campaigns = campaigns
        self.delegate = delegate
        self.navigationController = navigationController
    }
    
    func start() {
        if MFMailComposeViewController.canSendMail() {
            presentEmail()
        } else {
            presentErrorAlert { [weak self] in
                guard let self else { return }
                self.delegate?.coordinatorFinished(self)
            }
        }
    }
    
    private func presentEmail() {
        let emailViewController = newEmailViewController()
        navigationController.present(emailViewController, animated: true)
    }
    
    private func presentErrorAlert(_ completion: @escaping() -> Void) {
        let alertController = UIAlertController(title: "Could not open the mail app!", message: "Have you previously set it up?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        })
        alertController.addAction(action)
        navigationController.present(alertController, animated: true)
    }
    
    private func newEmailViewController() -> MFMailComposeViewController {
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

