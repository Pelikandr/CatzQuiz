//
//  UIImage+Network.swift
//  CatzQuiz
//
//  Created by pelikandr on 22.04.2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private var network: Network {
        return Network.shared
    }
    
    func setImage(from url: String?) {
        guard let url = url else { return }
        
        let loader = UIActivityIndicatorView()
        self.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.leadingAnchor.constraint(equalTo: leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: trailingAnchor),
            loader.topAnchor.constraint(equalTo: topAnchor),
            loader.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        loader.startAnimating()
        
        network.saveImage(from: url) { [weak self, weak wLoader = loader] (error: Error?, url: URL?) in
            DispatchQueue.main.async {
                wLoader?.removeFromSuperview()
                guard let imagePath: String = url?.path else { return }
                self?.image = UIImage(contentsOfFile: imagePath)
            }
        }
    }
}
