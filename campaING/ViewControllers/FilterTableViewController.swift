//
//  CampaignBuilderTableViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

protocol CampaignFilteringUIRepresentableType: CampaignBuildingFilterCellCustomizing & CampaignBuilderFilteringDataType {}

final class FilterTableViewController<T: CampaignFilteringUIRepresentableType>: UITableViewController {
    let service: CampaignBuilderServiceProviding
    let viewModel: CampaignBuilderTableViewModel<T>
    let coordinator: CampaignBuilderCoordinator?
    let configuration: CampaignFilterViewControllerConfigurating
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.service = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader())
        self.viewModel = .init(dataProvider: service, step: .chooseTargetingSpecifics)
        self.coordinator = nil
        self.configuration = CampaignBuilderStep.chooseTargetingSpecifics.filterViewControllerConfiguration
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init?(coder: NSCoder, coordinator: CampaignBuilderCoordinator, step: CampaignBuilderStep = .chooseTargetingSpecifics, buildingService: CampaignBuilderServiceProviding) {
        self.service = buildingService
        self.viewModel = .init(dataProvider: service, step: step)
        self.coordinator = coordinator
        self.configuration = step.filterViewControllerConfiguration
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.service = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader())
        self.viewModel = .init(dataProvider: service, step: .chooseTargetingSpecifics)
        self.coordinator = nil
        self.configuration = CampaignBuilderStep.chooseTargetingSpecifics.filterViewControllerConfiguration
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
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        service.didSelectOption(service.dataFor(viewModel.step)[indexPath.row])
        tableView.reloadSections([0], with: .automatic)
        navigationItem.rightBarButtonItem?.isHidden = service.selectedOptionsFor(viewModel.step).isEmpty
    }
}

// MARK: Setup
extension FilterTableViewController {
    func setup() {
        tableView.dataSource = viewModel
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        navigationItem.title = configuration.title
        if configuration.shouldShowRightBarbutton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: configuration.rightBarButtonTitle, style: .plain, target: self, action: #selector(didTapNext))
        }
        if configuration.shouldShowLeftBarbutton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapPrevious))
        }
        
        if viewModel.step.previous != nil {
            
        }
    }
}

