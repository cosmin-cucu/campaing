//
//  ChooseCampaignCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

class ChooseCampaignCoordinator: ChildCoordinator {
    weak var delegate: ChildCoordinatorDelegate?
    let channel: CampaignChannel
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, delegate: ChildCoordinatorDelegate, channel: CampaignChannel) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.channel = channel
    }
    
    func start() {
        let chooseCampaignViewController = ChooseCampaignViewController.instantiate(channel, campaignProvider: LocalJSONCampaignLoader())
        chooseCampaignViewController.delegate = self
        navigationController.present(chooseCampaignViewController, animated: true)
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        // NO-OP
    }
}

extension ChooseCampaignCoordinator: ChooseCampaignViewControllerDelegate {
    func finishedSelection(_ campaign: Campaign?) {
        delegate?.coordinatorFinished(self)
    }
}
