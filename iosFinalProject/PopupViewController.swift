//
//  PopupViewController.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-21.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var lable2: UILabel!
    @IBOutlet weak var lable3: UILabel!
    @IBOutlet weak var lable4: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    var item : Table_iTunes?
    
    
    
    
    @IBAction func close(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 5
        popupView.layer.masksToBounds = true
        
        priceView.layer.cornerRadius = 5
        priceView.layer.masksToBounds = true
        
        price.layer.cornerRadius = 5
        price.layer.masksToBounds = true
        
        btnClose.layer.cornerRadius = 10
        btnClose.layer.masksToBounds = true
        
        if let myItem = item {
            updateCell(item: myItem)
        }
    }
    
    func updateCell(item : Table_iTunes){
        myImage.image = item.image as? UIImage
        
        if let myName = item.trackName {
            lable1.text =  myName
        }
        if let myArtistName = item.artistName {
            lable2.text = myArtistName
        }
        if let myKind = item.kind {
            lable3.text = "Type : " + myKind
        }
        if let myInformation = item.information {
            lable4.text = "Info : " + myInformation
        }
        if let myPrice = item.price {
            price.text = "$" + myPrice
        }
    }
}















