//
//  ViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import UIKit

class CampaignBuilderViewController: UITableViewController {
   let viewModel: CampaignBuilderViewModel
    
    init(viewModel: CampaignBuilderViewModel) {
        self.viewModel = viewModel
        super.init()
        self.viewLayoutMarginsDidChange()
    }
    
    required init?(coder: NSCoder) {
        viewModel = .init()
        super.init(coder: coder)
    }
}
