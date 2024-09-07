//
//  campaINGTests.swift
//  campaINGTests
//
//  Created by Cosmin Cucu on 18/8/24.
//

import XCTest
@testable import campaING
    

final class CampaignBuilderServiceTests: XCTestCase {
    var service: CampaignBuilderServiceProviding!
    
    override func setUp() async throws {
        service = CampaignBuilderService(targetingSpecificsProvider:
                                            FakeTargetingSpecificsProvider(),
                                         campaignProvider: FakeCampaignProvider())
        try await super.setUp()
    }
    
    func testSelectingConflictingChannelsFilter() {
        XCTAssertEqual(service.availableSpecifics.count, 3)
        service.didSelectOption(FakeTargetingSpecificsProvider().targetingSpecifics[0])
        XCTAssertEqual(service.availableSpecifics.count, 1)
    }
    
    func testSelectingNonConflitingChannelsFilter() {
        XCTAssertEqual(service.availableSpecifics.count, 3)
        service.didSelectOption(FakeTargetingSpecificsProvider().targetingSpecifics[1])
        XCTAssertEqual(service.availableSpecifics.count, 2)
    }
    
    func testSubmittingOptions() {
        let fakeCampaign = Campaign(price: 0, listings: "2-3", optimizations: 2, features: ["all the featrures"])
        let fakeChannel = CampaignChannel(identifier: "FakeChannel", campaigns: [fakeCampaign])
        service.didSelectOption(fakeChannel)
        XCTAssertEqual(service.selectedCampaignChannel, fakeChannel)
        
        service.didSelectOption(fakeCampaign)
        XCTAssertEqual(service.selectedCampaigns[fakeChannel], fakeCampaign)
        
        XCTAssertThrowsError(try service.selectedOptionsFor(.chooseCampaign)) { error in
            XCTAssertEqual(error as? CampaignBuilderDataReadingError, .stepShouldReadNoData)
        }
        
        XCTAssertThrowsError(try service.selectedOptionsFor(.summary)) { error in
            XCTAssertEqual(error as? CampaignBuilderDataReadingError, .stepShouldReadNoData)
        }

    }
    
    func testCannotSubmitMultipleCampaignsForSameChannel() {
        let fakeCampaign = Campaign(price: 0, listings: "2-3", optimizations: 2, features: ["all the featrures"])
        let otherFakeCampaign = Campaign(price: 20, listings: "1", optimizations: nil, features: ["some of the features"])
        let fakeChannel = CampaignChannel(identifier: "FakeChannel", campaigns: [fakeCampaign, otherFakeCampaign])
        service.didSelectOption(fakeChannel)
        service.didSelectOption(fakeCampaign)

        XCTAssertEqual(service.selectedCampaigns[fakeChannel], fakeCampaign)
        
        service.didSelectOption(otherFakeCampaign)
        XCTAssertEqual(service.selectedCampaigns[fakeChannel], otherFakeCampaign)
    }
    
    func testSubmittingSpecificsTwiceRemoves() {
        let specific = TargetingSpecific(name: "Fake Specific", campaignChannels: [])
        service.didSelectOption(specific)
        XCTAssertEqual(service.selectedSpecifics.count, 1)
        XCTAssertEqual(service.selectedSpecifics, [specific])
        service.didSelectOption(specific)
        XCTAssertEqual(service.selectedSpecifics.count, 0)
    }
    
    func testDataReading() {
        guard let targetingSpecificsData = try? service.dataFor(.chooseTargetingSpecifics) as? [TargetingSpecific] else {
            XCTFail("Data for targetingSpecifics is not of type [TargetingSpecific]")
            return
        }
        XCTAssertEqual(targetingSpecificsData, FakeTargetingSpecificsProvider().targetingSpecifics)
        
        guard let campaignChannelData = try? service.dataFor(.chooseCampaignChannel) as? [Campaign] else {
            XCTFail("Data for campaigns is not of type [Campaign]")
            return
        }
        
        XCTAssert(campaignChannelData.isEmpty)
        
        XCTAssertThrowsError(try service.dataFor(.chooseCampaign)) { error in
            XCTAssertEqual(error as? CampaignBuilderDataReadingError, .stepShouldReadNoData)
        }
        
        XCTAssertThrowsError(try service.dataFor(.summary)) { error in
            XCTAssertEqual(error as? CampaignBuilderDataReadingError, .stepShouldReadNoData)
        }
        
    }
}
