//
//  TableViewCell.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-19.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var information: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    
    func updateCell(item : Table_iTunes){
        picture.image = item.image as? UIImage
        
        if let myName = item.trackName {
            name.text =  myName
        }
        if let myArtistName = item.artistName {
            information.text = myArtistName
        }
        if let myPrice = item.price , let mykind = item.kind
        
        {
            price.text = mykind + " : " + myPrice + "$"
        }

    }
    
    

}






