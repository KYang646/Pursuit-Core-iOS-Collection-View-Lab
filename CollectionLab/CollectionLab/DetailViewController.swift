//
//  DetailViewController.swift
//  CollectionLab
//
//  Created by Kimball Yang on 9/29/19.
//  Copyright © 2019 Kimball Yang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var country: Country!
    
    @IBOutlet weak var daImage: UIImageView!
    @IBOutlet weak var daName: UILabel!
    @IBOutlet weak var daCapital: UILabel!
    @IBOutlet weak var daPop: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    private func loadData() {
        daName.text = country.name
        daCapital.text = country.capital
        daPop.text = country.population.formattedWithSeparator
        
        let urlStr = "https://www.countryflags.io/\(country.alpha2Code.lowercased())/shiny/64.png"
        ImageHelper.shared.getImage(urlStr: urlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.daImage.image = image
                }
            }
        }
    }

    

}
