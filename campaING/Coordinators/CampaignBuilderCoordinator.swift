//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class CampaignBuilderCoordinator: NSObject, Coordinator {
    private var currentStep: CampaignBuilderStep = .chooseTargetingSpecifics
    let buildingService: CampaignBuilderServiceProviding = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader())
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let newViewController = newViewControllerFor(currentStep, dataType: TargetingSpecific.self)
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    @objc func pushFlowToNextStep() {
        guard let nextStep = currentStep.next else { return }
        currentStep = nextStep
        navigationController.pushViewController(newViewControllerFor(nextStep, dataType: CampaignChannel.self), animated: true)
    }
    
    @objc func popFlowToPreviousStep() {
        guard let previousStep = currentStep.previous else { return }
        currentStep = previousStep
        navigationController.popViewController(animated: true)
    }
}

extension CampaignBuilderCoordinator {
    func newViewControllerFor<T: CampaignBuildingRepresentableType>(
        _ step: CampaignBuilderStep, dataType: T.Type) -> CampaignBuilderTableViewController<T> {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "CampaignBuilderTableViewController", creator: { [weak self] coder in
            guard let self = self else { fatalError("Could not instantiate CampaignBuilderTableViewController") }
            let viewController = CampaignBuilderTableViewController<T>(coder: coder, coordinator: self, step: step, buildingService: buildingService)
            return viewController
        }) as? CampaignBuilderTableViewController<T> else {
            fatalError("Could not instantiate CampaignBuilderTableViewController")
        }
        
        return campaignBuilderTableViewController
    }
}
