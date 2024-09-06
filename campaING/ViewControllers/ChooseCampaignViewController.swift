//
//  ChooseCampaignViewControllerDelegate.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import UIKit

protocol ChooseCampaignViewControllerDelegate: AnyObject {
    func finishedSelection(_ campaign: Campaign)
}

class ChooseCampaignViewController: UICollectionViewController {
    weak var delegate: ChooseCampaignViewControllerDelegate?
    private var campaigns: [Campaign]
    private var chosenCampaign: Campaign?
    
    static func instantiate(campaigns: [Campaign]) -> ChooseCampaignViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(identifier: "ChooseCampaignViewController", creator: { coder in
            ChooseCampaignViewController(coder: coder, campaigns: campaigns)
        })
    }
    
    init?(coder: NSCoder, campaigns: [Campaign]) {
        self.campaigns = campaigns
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init? not implemented!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionViewLayout = newLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCampaignCollectionViewCell", for: indexPath) as? ChooseCampaignCollectionViewCell else {
            return UICollectionViewCell()
        }
        campaigns[indexPath.row].customize(cell)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let campaign = campaigns[indexPath.row]
        if campaign == chosenCampaign {
            collectionView.deselectItem(at: indexPath, animated: true)
            chosenCampaign = nil
        } else {
            chosenCampaign = campaign
        }
        
        updateRightBarButton()
    }
    
    private func updateRightBarButton() {
        guard chosenCampaign != nil else {
            navigationItem.setRightBarButton(nil, animated: true)
            return
        }
        
        let barbutton = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitSelection))
        navigationItem.setRightBarButton(barbutton, animated: true)
    }
    
    @objc private  func submitSelection() {
        guard let chosenCampaign else  { return }
        navigationController?.dismiss(animated: true)
        delegate?.finishedSelection(chosenCampaign)
    }
    
    private func newLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(view.frame.width / 2),
            heightDimension: .estimated(600))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .flexible(8), top: .flexible(0),
            trailing: .flexible(8), bottom: .flexible(0))
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(
            section: section, configuration:config)
        return layout
    }
}
