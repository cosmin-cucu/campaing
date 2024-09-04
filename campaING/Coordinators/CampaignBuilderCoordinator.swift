//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

enum BuilderStep {
    case chooseTargetingSpecifics
    case chooseCampaignChannel
    case chooseCampaign
}

struct CampaignBuilderCoordinator: Coordinator {
    private var currentStep: BuilderStep = .chooseTargetingSpecifics
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "CampaignBuilderTableViewController")
        navigationController.pushViewController(campaignBuilderTableViewController, animated: true)
    }
}
