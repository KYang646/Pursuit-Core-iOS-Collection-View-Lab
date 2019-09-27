//
//  ViewController.swift
//  CollectionLab
//
//  Created by Kimball Yang on 9/26/19.
//  Copyright © 2019 Kimball Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
 @IBOutlet weak var flagCollection: UICollectionView!
    var nations = [Country](){
        didSet {
            flagCollection.reloadData()
        }
    }
   
    func loadData() {
        CountryAPIClient.manager.getCountry { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.nations = data
                    dump(data)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagCollection.dataSource = self
        flagCollection.delegate = self
        loadData()
    }


}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = flagCollection.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as? flagCollectionViewCell else { return UICollectionViewCell() }
        let nat = nations[indexPath.row]
        ImageHelper.shared.getImage(urlStr: nat.getIMGurl(code: nat.alpha2Code)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell.image.image = image
                }
            }
        }
        cell.countryName.text = nat.name
        cell.capital.text = nat.capital
        cell.population.text = nat.population.description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 150)
    }
    
}

