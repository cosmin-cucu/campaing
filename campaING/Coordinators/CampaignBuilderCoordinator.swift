//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class CampaignBuilderCoordinator: ChildCoordinator, ChildCoordinatorDelegate {
    weak var delegate: ChildCoordinatorDelegate?
    var navigationController: UINavigationController
    private var currentStep: CampaignBuilderStep = .chooseTargetingSpecifics
    private var childCoordinators: [Coordinator] = []
    let buildingService: CampaignBuilderService
    
    init(navigationController: UINavigationController, delegate: ChildCoordinatorDelegate? = nil) {
        self.buildingService = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader(),
                                                      campaignProvider: LocalJSONCampaignLoader())
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    
    func start() {
        presentNewStep()
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    @objc func pushFlowToNextStep() {
        guard let nextStep = currentStep.next else { return }
        currentStep = nextStep
        presentNewStep()
    }
    
    @objc func popFlowToPreviousStep() {
        guard let previousStep = currentStep.previous else { return }
        currentStep = previousStep
        if currentStep.next?.isFilteringStep == true {
            navigationController.popViewController(animated: true)
        }
    }
    
    private func presentNewStep() {
        if currentStep.isFilteringStep {
            presentNewFilteringViewController()
        } else {
            attachChildCoordinator(for: currentStep)
        }
    }
    
    private func attachChildCoordinator(for step: CampaignBuilderStep) {
        let child = ChooseCampaignCoordinator(navigationController: navigationController, delegate: self, channel: buildingService.selectedCampaignChannel!)
        attachChild(child)
    }
    
    func presentNewFilteringViewController() {
        let type = currentStep.dataType
        guard let newViewController = newFilteringViewController(type) else {
            fatalError("Could not start the coorrdinator")
        }
        
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    func coordinatorFinished(_ coordinator: any Coordinator) {
        if coordinator is ChooseCampaignCoordinator,
           buildingService.selectedCampaign != nil{
            pushFlowToNextStep()
        } else {
            childCoordinators.removeLast()
            popFlowToPreviousStep()
        }
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


