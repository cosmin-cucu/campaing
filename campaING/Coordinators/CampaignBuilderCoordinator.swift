//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class CampaignBuilderCoordinator: NSObject, Coordinator {
    private var currentStep: CampaignBuilderStep = .chooseTargetingSpecifics
    private var childCoordinators: [Coordinator] = []
    let buildingService: CampaignBuilderService
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.buildingService = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader(),
                                                      campaignProvider: LocalJSONCampaignLoader())
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
    
    func attachChild(_ coordinator: any Coordinator) {
        
    }
    
    private func presentNewStep() {
        guard let type = currentStep.dataType else { return }
        guard let newViewController = newFilteringViewController(type) else {
            fatalError("Could not start the coorrdinator")
        }
        
        navigationController.pushViewController(newViewController, animated: true)
    }
}

extension CampaignBuilderCoordinator {
    func newFilteringViewController<T: BuilderTableViewRepresentableType>(
        _ dataType: T.Type) -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "BuilderTableViewController", creator: customizedViewController) as? BuilderTableViewController<T>
        
        return campaignBuilderTableViewController
    }
    
    func customizedViewController<T: BuilderTableViewRepresentableType>(_ coder: NSCoder) -> BuilderTableViewController<T>? {
        let viewController = BuilderTableViewController<T>(coder: coder, coordinator: self, step: currentStep, buildingService: buildingService)
        return viewController
    }
}
