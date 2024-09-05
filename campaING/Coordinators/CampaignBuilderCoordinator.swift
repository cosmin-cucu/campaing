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
        guard let newViewController = newFilteringViewController(type) else {
            fatalError("Could not start the coorrdinator")
        }
        
        navigationController.pushViewController(newViewController, animated: true)
    }
}

extension CampaignBuilderCoordinator {
    func newFilteringViewController<T: CampaignFilteringUIRepresentableType>(
        _ dataType: T.Type) -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "FilterTableViewController", creator: customizedViewController) as? FilterTableViewController<T>
        
        return campaignBuilderTableViewController
    }
    
    func customizedViewController<T: CampaignFilteringUIRepresentableType>(_ coder: NSCoder) -> FilterTableViewController<T>? {
        let viewController = FilterTableViewController<T>(coder: coder, coordinator: self, step: currentStep, buildingService: buildingService)
        return viewController
    }
}
