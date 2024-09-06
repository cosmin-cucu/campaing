//
//  CampaignBuilderTableViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

protocol BuilderTableViewRepresentableType: CampaignBuilderCellCustomizing & CampaignBuilderFilteringDataType {}

protocol BuilderTableViewDelegate: AnyObject {
    func submittedSelection()
    func wasDismissed()
}

final class BuilderTableViewController<T: BuilderTableViewRepresentableType>: UITableViewController {
    private let service: CampaignBuilderServiceProviding
    private let viewModel: CampaignBuilderTableViewModel<T>
    private let configuration: BuilderTableViewControllerConfigurating
    private let step: CampaignBuilderStep
    weak var delegate: BuilderTableViewDelegate?
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.service = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader(),
                                              campaignProvider: LocalJSONCampaignLoader())
        self.step = .chooseTargetingSpecifics
        self.viewModel = .init(dataProvider: service, step: step)
        self.delegate = nil
        self.configuration = BuilderTableViewConfiguration(.chooseTargetingSpecifics)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init?(coder: NSCoder, delegate: BuilderTableViewDelegate? = nil, step: CampaignBuilderStep = .chooseTargetingSpecifics, service: CampaignBuilderServiceProviding) {
        guard let configuration = step.viewControllerConfiguration as? BuilderTableViewControllerConfigurating else {
            fatalError("Could not instantiate the configuration!")
        }
        self.step = step
        self.service = service
        self.viewModel = .init(dataProvider: service, step: step)
        self.delegate = delegate
        self.configuration = configuration
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        guard let configuration = CampaignBuilderStep.chooseTargetingSpecifics.viewControllerConfiguration as? BuilderTableViewControllerConfigurating else {
            fatalError("Could not instantiate the configuration!")
        }
        self.step = .chooseTargetingSpecifics
        self.service = CampaignBuilderService(targetingSpecificsProvider: LocalJSONTargetingSpecificsLoader(),
                                              campaignProvider: LocalJSONCampaignLoader())
        self.viewModel = .init(dataProvider: service, step: step)
        self.delegate = nil
        self.configuration = configuration
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc private  func didTapNext(_ sender: Any) {
        delegate?.submittedSelection()
    }
    
    @objc private  func didTapPrevious() {
        delegate?.wasDismissed()
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submitSelectionAt(indexPath)
        tableView.reloadSections([0], with: .automatic)
        navigationItem.rightBarButtonItem?.isHidden = !viewModel.isDataSelected
    }
    
    private func submitSelectionAt(_ indexPath: IndexPath) {
        service.didSelectOption(service.dataFor(step)[indexPath.row])
        if step.next?.isFilteringStep == false {
            delegate?.submittedSelection()
        }
    }
}

// MARK: Setup
extension BuilderTableViewController {
    private func setup() {
        tableView.dataSource = viewModel
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = configuration.title
        if configuration.shouldShowRightBarbutton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: configuration.rightBarButtonTitle, style: .plain, target: self, action: #selector(didTapNext))
            navigationItem.rightBarButtonItem?.isHidden = true
        }

        if configuration.shouldShowLeftBarbutton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapPrevious))
        }
    }
}


