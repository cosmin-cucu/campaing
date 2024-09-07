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
    
    init(service: CampaignBuilderServiceProviding, delegate: ChildCoordinatorDelegate, navigationController: UINavigationController) {
        guard let channel = service.selectedCampaignChannel else {
            fatalError("Trying to select a campaign without a selected channel")
        }
        
        self.service = service
        self.navigationController = navigationController
        self.delegate = delegate
        self.channel = channel
    }
    
    func start() {
        let campaignsProvider = LocalJSONCampaignLoader()
        let campaigns = campaignsProvider.campaignsFor(channel.identifier)
        let chooseCampaignViewController = ChooseCampaignViewController.instantiate(campaigns: campaigns)
        chooseCampaignViewController.delegate = self
        let newNavigationController = UINavigationController(rootViewController: chooseCampaignViewController)
        navigationController.present(newNavigationController, animated: true)
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
