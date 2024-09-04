//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class CampaignBuilderCoordinator: NSObject, Coordinator {
    private var currentStep: CampaignBuilderStep = .chooseTargetingSpecifics
    let buildingService: CampaignBuilding = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader())
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.pushViewController(newViewControllerFor(currentStep), animated: true)
    }
    
    @objc func pushFlowToNextStep() {
        guard let nextStep = currentStep.next else { return }
        currentStep = nextStep
        navigationController.pushViewController(newViewControllerFor(nextStep), animated: true)
    }
    
    @objc func popFlowToPreviousStep() {
        guard let previousStep = currentStep.previous else { return }
        currentStep = previousStep
        navigationController.popViewController(animated: true)
    }
}

extension CampaignBuilderCoordinator {
    func newViewControllerFor(_ step: CampaignBuilderStep) -> CampaignBuilderTableViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "CampaignBuilderTableViewController", creator: { [weak self] coder in
            guard let self = self else { fatalError("Could not instantiate CampaignBuilderTableViewController") }
            let viewController = CampaignBuilderTableViewController(coder: coder, coordinator: self, step: step, buildingService: buildingService)
            return viewController
        }) as? CampaignBuilderTableViewController else {
            fatalError("Could not instantiate CampaignBuilderTableViewController")
        }
        
        return campaignBuilderTableViewController
    }
}
