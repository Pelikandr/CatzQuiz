//
//  GuideAdapter.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation
import UIKit

class GuideAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var breeds = [Breed]()
    var onCatSelected: ((Breed) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(breeds.count)
        return 9//breeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCollectionViewCell
//        cell.titleLabel.text = breeds[indexPath.row].name
//        cell.catImageView.image = UIImage(named: "company")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCatSelected?(breeds[indexPath.row].self)
    }
    
    
}
