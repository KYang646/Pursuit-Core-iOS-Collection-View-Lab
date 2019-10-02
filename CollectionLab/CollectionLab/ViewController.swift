//
//  ViewController.swift
//  CollectionLab
//
//  Created by Kimball Yang on 9/26/19.
//  Copyright © 2019 Kimball Yang. All rights reserved.
//

import UIKit
import Foundation

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
        cell.population.text = nat.population.formattedWithSeparator
        //
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? flagCollectionViewCell, let indexPath = self.flagCollection.indexPath(for: cell) {
        
            let detailVC = segue.destination as! DetailViewController
            detailVC.country = nations[indexPath.row]
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let segueIdentifier = segue.identifier else {fatalError("No identifier in segue")}
//        
//        switch segueIdentifier {
//            
//        case "traverse":
//            guard let destVC = segue.destination as? DetailViewController else {
//                fatalError("Unexpected segue VC")
//            }
//            guard let selectedIndexPath =
//        }
//    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
         guard let segueIdentifer = segue.identifier else {fatalError("No indentifier in segue")}
         
         switch segueIdentifer {
             
         case "segToTableView":
             guard let destVC = segue.destination as? EpisodeViewController else {
                 fatalError("Unexpected segue VC")
             }
             guard let selectedIndexPath = showsTableView.indexPathForSelectedRow else {fatalError("No row selected")
                 
             }
             
             let currentShow = filteredShow[selectedIndexPath.row]
             destVC.show = currentShow
             
         default:
             fatalError("unexpected segue identifier")
             
         }
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 190)
    }
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
