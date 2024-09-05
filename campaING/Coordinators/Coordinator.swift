//
//  Coordinator.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
    func attachChild(_ coordinator: Coordinator)
}

protocol ChildCoordinatorDelegate: AnyObject {
    func coordinatorFinished(_ coordinator: Coordinator)
}

protocol ChildCoordinator: Coordinator {
    var delegate: ChildCoordinatorDelegate? { get set }
}
