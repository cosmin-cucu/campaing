//
//  CampaignBuilderCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class CampaignBuilderCoordinator: ChildCoordinator {
    weak var delegate: ChildCoordinatorDelegate?
    var navigationController: UINavigationController
    private(set) var currentStep: CampaignBuilderStep = .chooseTargetingSpecifics
    private var childCoordinators: [Coordinator] = []
    private let buildingService: CampaignBuilderServiceProviding
    
    convenience init(navigationController: UINavigationController, delegate: ChildCoordinatorDelegate? = nil) {
        self.init(navigationController: navigationController, buildingService: CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader(),
                                                                                                      campaignProvider: LocalJSONCampaignLoader()),
                  delegate: delegate)
    }
    
    init(navigationController: UINavigationController, buildingService: CampaignBuilderServiceProviding, delegate: ChildCoordinatorDelegate? = nil) {
        self.buildingService = buildingService
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
                                              navigationController: navigationController)
        attachChild(child)
    }
    
    private func presentNewFilteringViewController() {
        let type = currentStep.dataType
        guard let newViewController = newFilteringViewController(type) else {
            fatalError("Could not start the coorrdinator")
        }
        
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    private func updateRightBarButton() {
        navigationController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pushFlowToNextStep))
    }
}

extension CampaignBuilderCoordinator {
    private func newFilteringViewController<T: BuilderTableViewRepresentableType>(
        _ dataType: T.Type) -> UIViewController? {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let campaignBuilderTableViewController = mainStoryboard.instantiateViewController(identifier: "BuilderTableViewController", creator: customizedViewController) as? BuilderTableViewController<T>
            
            return campaignBuilderTableViewController
        }
    
    private func customizedViewController<T: BuilderTableViewRepresentableType>(_ coder: NSCoder) -> BuilderTableViewController<T>? {
        let viewController = BuilderTableViewController<T>(coder: coder, delegate: self, step: currentStep, service: buildingService)
        return viewController
    }
}

extension CampaignBuilderCoordinator: ChildCoordinatorDelegate {
    func coordinatorFinished(_ coordinator: any Coordinator) {
        defer {
            childCoordinators.removeLast()
        }
        
        if coordinator is ChooseCampaignCoordinator,
           !buildingService.selectedCampaigns.isEmpty {
            updateRightBarButton()
        } else {
            popFlowToPreviousStep()
        }
    }
}

extension CampaignBuilderCoordinator: BuilderTableViewDelegate {
    func wasDismissed() {
        popFlowToPreviousStep()
    }
    func submittedSelection() {
        pushFlowToNextStep()
    }
}

extension CampaignBuilderCoordinator: ChosenCampaignsSummaryViewControllerDelegate {
    func summaryViewControllerWasDismissed() {
        guard currentStep == .summary else { return }
        currentStep = .chooseCampaignChannel
    }
    func submitCampaigns() {
        let submitCampaignCoordinator = SubmitCampaignCoordinator(delegate: self, campaigns: buildingService.selectedCampaigns, navigationController: navigationController)
        attachChild(submitCampaignCoordinator)
    }
}
