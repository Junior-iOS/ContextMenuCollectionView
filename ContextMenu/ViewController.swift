//
//  ViewController.swift
//  ContextMenuInCollection
//
//  Created by Junior Silva on 25/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray6
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        return collection
    }()
    
    let imageNames = Array(1...6).map { "hacker\($0)" }
    var favorites = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

// MARK: - DELEGATES and DATASOURCE
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { fatalError() }
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 2) - 4, height: (view.frame.size.width / 2) - 4)
    }
    
    // MARK: - THIS IS WHERE THE MAGIC HAPPENS
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            
            let copy = UIAction(title: "Copy", image: UIImage(systemName: "link"), state: .off) { _ in
                print("Tapped Copy")
            }
            
            let title = self?.favorites.contains(indexPath.row) == true ? "Remove Favorite" : "Favorite"
            let image = self?.favorites.contains(indexPath.row) == true ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            
            let favorite = UIAction(title: title, image: image, state: .off) { [weak self] _ in
                if self?.favorites.contains(indexPath.row) == true {
                    self?.favorites.removeAll(where: { $0 == indexPath.row })
                } else {
                    self?.favorites.append(indexPath.row)
                }
            }
            
            let search = UIAction(title: "Search", image: UIImage(systemName: "magnifyingglass"), state: .off) { _ in
                print("Tapped search")
            }
            
            return UIMenu(title: "Actions",
                          image: nil,
                          identifier: nil,
                          options: UIMenu.Options.displayInline,
                          children: [copy, favorite, search]
            )
        }
        
        return config
    }
}
