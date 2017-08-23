//
//  CollectionViewCell.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-20.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    
    func updateCell(item : Table_iTunes){
        image.image = item.image as? UIImage
        
    }

}
