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
        presentNewStep()
    }
    
    @objc func pushFlowToNextStep() {
        guard let nextStep = currentStep.next else { return }
        currentStep = nextStep
        presentNewStep()
    }
    
    @objc func popFlowToPreviousStep() {
        guard let previousStep = currentStep.previous else { return }
        currentStep = previousStep
        navigationController.popViewController(animated: true)
    }
    
    private func presentNewStep() {
        let type = currentStep.dataType
        guard let newViewController = newViewControllerFor(type) else {
            fatalError("Could not start the coorrdinator")
        }
        
        navigationController.pushViewController(newViewController, animated: true)
    }
}

extension CampaignBuilderCoordinator {
    func newViewControllerFor<T: CampaignBuildingRepresentableType>(
        _ dataType: T.Type) -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "CampaignBuilderTableViewController", creator: customizedViewController) as? CampaignBuilderTableViewController<T>
        
        return campaignBuilderTableViewController
    }
    
    func customizedViewController<T: CampaignBuildingRepresentableType>(_ coder: NSCoder) -> CampaignBuilderTableViewController<T>? {
        let viewController = CampaignBuilderTableViewController<T>(coder: coder, coordinator: self, step: currentStep, buildingService: buildingService)
        return viewController
    }
}
