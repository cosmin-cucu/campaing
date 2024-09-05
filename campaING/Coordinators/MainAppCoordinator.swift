//
//  MainCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

class MainAppCoordinator: Coordinator {
    private var childCoordinators: [Coordinator]
    let navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
        childCoordinators = [CampaignBuilderCoordinator(navigationController: navigationController)]
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        childCoordinators.forEach { $0.start() }
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
