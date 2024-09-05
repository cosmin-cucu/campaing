//
//  MainCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
    func attachChild(_ coordinator: Coordinator)
}

class MainCoordinator: Coordinator {
    private var childCoordinators: [Coordinator]
    let navigationController = UINavigationController()
    
    init() {
        childCoordinators = [CampaignBuilderCoordinator(navigationController: navigationController)]
    }
    
    func start() {
        childCoordinators.forEach { $0.start() }
    }
    
    func attachChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
