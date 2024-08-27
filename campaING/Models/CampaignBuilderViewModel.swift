//
//  CampaignBuilderViewModel.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import Foundation

struct CampaignBuilderViewModel {
    let specifics: [TargetingSpecific]

    init() {
        self.specifics = readTargetingSpecificsJSONFromFile()
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
