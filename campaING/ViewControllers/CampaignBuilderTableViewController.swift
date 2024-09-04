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
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = .init(builderService: service)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = .init(builderService: service)
        super.init(coder: coder)
    }

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

extension CampaignBuilderTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        service.didSelectFilterAt(indexPath.row)
        tableView.reloadSections([0], with: .automatic)
    }
}

