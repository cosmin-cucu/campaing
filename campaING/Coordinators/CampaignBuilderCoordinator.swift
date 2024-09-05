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
        guard currentStep != .chooseCampaign else {
            attachChooseCampaignCoordinator()
            return
        }
        guard currentStep.next != nil else {
            presentSummary()
            return
        }
        presentNewFilteringViewController()
    }
    
    private func presentSummary() {
        let viewController = ChosenCampaignsSummaryViewController.instantiate(self, buildingService.selectedCampaigns)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func attachChooseCampaignCoordinator() {
        let child = ChooseCampaignCoordinator(service: buildingService,
                                              delegate: self,
                                              channel: buildingService.selectedCampaignChannel!,
                                              navigationController: navigationController)
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
        defer {
            childCoordinators.removeLast()
        }
        
        if coordinator is ChooseCampaignCoordinator,
           !buildingService.selectedCampaigns.isEmpty {
            updateRightBarButton()
        } else {
            childCoordinators.removeLast()
            popFlowToPreviousStep()
        }
    }
    
    private func updateRightBarButton() {
        navigationController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pushFlowToNextStep))
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

extension CampaignBuilderCoordinator: ChosenCampaignsSummaryViewControllerDelegate {
    func summaryViewControllerWasDismissed() {
        guard currentStep == .summary else { return }
        currentStep = .chooseCampaignChannel
    }
    
    func submitCampaigns() {
        let submitCampaignCoordinator = SubmitCampaignCoordinator(delegate: self, service: CampaignSubmitter(), campaigns: buildingService.selectedCampaigns, navigationController: navigationController)
        attachChild(submitCampaignCoordinator)
    }
}
