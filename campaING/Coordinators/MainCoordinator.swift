//
//  MainCoordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 4/9/24.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

struct MainCoordinator: Coordinator {
    private var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
        childCoordinators = [CampaignBuilderCoordinator(navigationController: navigationController)]
    }
    
    func start() {
        childCoordinators.forEach { $0.start() }
    }
}
