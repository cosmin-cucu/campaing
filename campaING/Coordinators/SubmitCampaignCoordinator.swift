//
//  SubmitCampaignCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

struct SubmitCampaignCoordinator: ChildCoordinator {
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
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        // NO-OP
    }    
}
