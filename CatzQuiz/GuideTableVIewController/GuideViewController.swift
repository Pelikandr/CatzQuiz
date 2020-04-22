//
//  GuideViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let adapter = GuideAdapter()
    var breeds = [Breed]()
    var selectedBreed: Breed?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        loader.startAnimating()
        
        getAllBreeds { [weak self] (breeds) in
            self?.breeds = breeds
            self?.setSampleImages() { [weak self] in
                guard let self = self else { return }
                self.loader.stopAnimating()
                self.adapter.breeds = self.breeds
                self.collectionView.reloadData()
            }
        }
        adapter.onCatSelected = { [weak self] (breed: Breed) in
            guard let self = self else { return }
            self.selectedBreed = breed
            self.performSegue(withIdentifier: "ShowCatzDetailsSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func onMenu(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setSampleImages(completion: (() -> Void)?) {
        let dispatchGroup = DispatchGroup()
        for i in 0..<breeds.count {
            dispatchGroup.enter()
            getImage(with: breeds[i].id) { [weak self] (image: CatImage) in
                guard let self = self else { return }
                self.breeds[i].sampleImageURL = image.url
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion?()
        }
    }

    private func getAllBreeds(completion: (([Breed]) -> Void)?) {
        Network.shared.getAllBreeds { (error: Error?, data: [Breed]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let data = data {
                completion?(data)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    private func getImage(with breedID: String, completion: ((CatImage) -> Void)?) {
        Network.shared.getImage(with: breedID) { (error: Error?, image: [CatImage]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let image = image?.first {
                completion?(image)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if let next = segue.destination as? GuideDetailTableViewController {
            next.breed = selectedBreed
        }
    }
    
}
