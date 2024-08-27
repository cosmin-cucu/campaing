struct CampaignBuilderTableViewModel {
    private let targetingSpecifics: [TargetingSpecific] = readTargetingSpecificsJSONFromFile()
    
    var numberOfFilters: Int {
        return targetingSpecifics.count
    }
    
    func customizeCell(_ cell: TargetingSpecificCell, for row: Int) {
        cell.customizeWith(targetingSpecifics[row])
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
