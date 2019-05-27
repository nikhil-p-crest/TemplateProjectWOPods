//
//  CollectionViewExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func reloadInMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func registerCell(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
}
