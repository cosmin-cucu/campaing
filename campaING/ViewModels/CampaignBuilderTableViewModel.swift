//
//  CampaignBuilderTableViewModel.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

class CampaignBuilderTableViewModel<T: BuilderTableViewRepresentableType>: NSObject, UITableViewDataSource {
    private let step: CampaignBuilderStep
    let dataProvider: CampaignBuilderDataProviding
    var isDataSelected: Bool {
        guard let data = try? dataProvider.selectedOptionsFor(step) else { return false}
         return !data.isEmpty
    }
    
    init(dataProvider: CampaignBuilderDataProviding, step: CampaignBuilderStep = .chooseTargetingSpecifics) {
        self.dataProvider = dataProvider
        self.step = step
    }
    
    func customizeCell(_ cell: CampaignBuilderTableViewCell, for row: Int) {
        guard let element = try? dataProvider.dataFor(step)[row] as? (T),
        let selectedElements = try? dataProvider.selectedOptionsFor(step) as? [T] else { return }
        let isCellSelected = selectedElements.contains(element)
        element.customize(cell, isSelected: isCellSelected)
    }
 
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (try? dataProvider.dataFor(step).count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let targetingSpecificCell = tableView.dequeueReusableCell(withIdentifier: "CampaignBuilderTableViewCell", for: indexPath) as? CampaignBuilderTableViewCell else {
            return UITableViewCell()
        }
        customizeCell(targetingSpecificCell, for: indexPath.row)
        return targetingSpecificCell
    }
}

