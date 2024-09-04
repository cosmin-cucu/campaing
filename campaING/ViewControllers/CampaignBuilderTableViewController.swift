//
//  CampaignBuilderTableViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

final class CampaignBuilderTableViewController: UITableViewController {
    let service: CampaignBuilderService = CampaignBuilderService()
    let viewModel: CampaignBuilderTableViewModel
    let step: CampaignBuilderStep
    let coordinator: CampaignBuilderCoordinator?
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.step = .chooseTargetingSpecifics
        self.viewModel = .init(builderService: service)
        self.coordinator = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init?(coder: NSCoder, coordinator: CampaignBuilderCoordinator, step: CampaignBuilderStep = .chooseTargetingSpecifics) {
        self.viewModel = .init(builderService: service)
        self.step = step
        self.coordinator = coordinator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.step = .chooseTargetingSpecifics
        self.viewModel = .init(builderService: service)
        self.coordinator = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        coordinator?.pushFlowToNextStep()
    }
    
    @objc func didTapPrevious() {
        coordinator?.popFlowToPreviousStep()
    }
}

// MARK: Setup
extension CampaignBuilderTableViewController {
    func setup() {
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        navigationItem.title = step.title
        navigationItem.rightBarButtonItem?.title = step.rightBarButtonTitle
        
        if step.previous != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapPrevious))
        }
    }
}

// MARK: UITableViewDataSource methods
extension CampaignBuilderTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFilters
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let targetingSpecificCell = tableView.dequeueReusableCell(withIdentifier: "TargetingSpecificCell", for: indexPath) as? TargetingSpecificCell else {
            return UITableViewCell()
        }
        viewModel.customizeCell(targetingSpecificCell, for: indexPath.row)
        return targetingSpecificCell
    }
}

// MARK: UITableViewDelegate methods
extension CampaignBuilderTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        service.didSelectFilterAt(indexPath.row)
        tableView.reloadSections([0], with: .automatic)
    }
}

