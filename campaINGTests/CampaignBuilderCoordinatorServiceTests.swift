//
//  CampaignBuilderCoordinatorServiceTests.swift
//  campaING
//
//  Created by Cosmin Cucu on 7/9/24.
//

import XCTest
@testable import campaING


class CampaignBuilderCoordinatorServiceTests: XCTestCase {
    
    let coordinator = CampaignBuilderCoordinator(navigationController: UINavigationController(), buildingService: FakeCampaignBuilderServiceProvider())
    
    func testStepAdvancing() {
        coordinator.start()
        XCTAssertEqual(coordinator.currentStep, .chooseTargetingSpecifics)
        coordinator.pushFlowToNextStep()

        XCTAssertEqual(coordinator.currentStep, .chooseCampaignChannel)
        coordinator.pushFlowToNextStep()
        XCTAssertEqual(coordinator.currentStep, .chooseCampaign)
        coordinator.pushFlowToNextStep()
        XCTAssertEqual(coordinator.currentStep, .summary)
    }
    
    
    func testChildCoordinatorDetachmentPopsToPreviousStep() {
        let channel = CampaignChannel(identifier: "FakeChannel")
        let childCoordinator = SubmitCampaignCoordinator(delegate: coordinator, campaigns: [channel: FakeCampaignProvider().campaignsFor(channel.identifier).first!], navigationController: coordinator.navigationController)
        coordinator.start()
        XCTAssertEqual(coordinator.currentStep, .chooseTargetingSpecifics)
        coordinator.pushFlowToNextStep()
        XCTAssertEqual(coordinator.currentStep, .chooseCampaignChannel)
        coordinator.attachChild(childCoordinator)
        coordinator.coordinatorFinished(childCoordinator)
        XCTAssertEqual(coordinator.currentStep, .chooseTargetingSpecifics)
    }
}
