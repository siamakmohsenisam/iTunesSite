//
//  InputFromWeb.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-19.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//


import UIKit


class InputFromWeb {
    
    
    private let FIRST_URL_COMMAND = "https://itunes.apple.com/search?term="
    private let SECOUND_URL_COMMAND  = "&entity="
    
    
    public func downloadVariables( artistNameOfURL: String, kindOfURL: String) -> [Dictionary<String, AnyObject>] {
        
        let urlString = "\(FIRST_URL_COMMAND)\(artistNameOfURL)\(SECOUND_URL_COMMAND)\(kindOfURL)"
        if let url = URL(string: urlString){
            do{
                let contents = try Data(contentsOf: url)
                if let json = try JSONSerialization.jsonObject(with: contents, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    // Dictionary   ***************
                    
                    if let results = json["results"] as? [Dictionary<String, AnyObject>]{
                        
                        return results
                    }
                }
            }catch{}
        }
        return [Dictionary<String, AnyObject>()]
    }
}
