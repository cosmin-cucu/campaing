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
    let service: CampaignBuilderServiceProviding
    
    init(service: CampaignBuilderServiceProviding, delegate: ChildCoordinatorDelegate, channel: CampaignChannel) {
        self.service = service
        self.navigationController = UINavigationController()
        self.delegate = delegate
        self.channel = channel
    }
    
    func start() {
        let chooseCampaignViewController = ChooseCampaignViewController.instantiate(channel, campaignProvider: LocalJSONCampaignLoader())
        chooseCampaignViewController.delegate = self
        navigationController.setViewControllers([chooseCampaignViewController], animated: false)
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        // NO-OP
    }
}

extension ChooseCampaignCoordinator: ChooseCampaignViewControllerDelegate {
    func finishedSelection(_ campaign: Campaign) {
        service.didSelectOption(campaign)
        delegate?.coordinatorFinished(self)
    }
}
