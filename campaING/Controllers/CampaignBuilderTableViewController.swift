//
//  CampaignBuilderTableViewController.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import UIKit

class CampaignBuilderTableViewController: UITableViewController {
    let targetingSpecifics: [TargetingSpecific] = readTargetingSpecificsJSONFromFile()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetingSpecifics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let targetingSpecificCell = tableView.dequeueReusableCell(withIdentifier: "TargetingSpecificCell", for: indexPath) as? TargetingSpecificCell else {
            return UITableViewCell()
        }
        targetingSpecificCell.customizeWith(targetingSpecifics[indexPath.row])
        return targetingSpecificCell
    }
    
    
}


fileprivate func readTargetingSpecificsJSONFromFile() -> [TargetingSpecific] {
    let fileName = "TargetingSpecifics.json"
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldn't find file \(fileName)")
    }
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode([TargetingSpecific].self, from: data)
    } catch let error {
        print("Error decoding JSON: \(error)")
        return []
    }
}
