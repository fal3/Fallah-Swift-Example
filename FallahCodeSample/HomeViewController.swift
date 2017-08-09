//
//  ViewController.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import PromiseKit

class HomeViewController: UITableViewController {
    private var photos: [Result<GMSPlacePhotoMetadata>] = []
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlacesCell.self, forCellReuseIdentifier: PlacesCell.reuseId)
        setNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard places.isEmpty else { return }
        if LocationUtil.didAllowLocation {
            reload()
        } else {
            LocationUtil.getPermission(containingVC: self)
        }
    }

    //MARK: - Helper Methods 
    
    private func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: nil, action: #selector(refresh))
        navItem.rightBarButtonItem = refreshItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc private func refresh() {
        reload()
    }
    
    private func reload() {
        firstly {
            fetchPlacesAndPhotos()
            }.then {
                self.tableView.reloadData()
            }.catch {
                self.showAlert(title: "Error", msg: $0.localizedDescription)
        }
    }
    
    private func fetchPlacesAndPhotos() -> Promise<Void> {
        return firstly {
            PlacesUtil.fetchPlaces()
        }.then { hoods in
            PlacesUtil.fetchPhotosForPlaces(likelihoods: hoods).then{ ($0, hoods) }
        }.then { pics, hoods -> Void in            
            self.places = zip(hoods,pics).map{ Place(hood: $0, result: $1) }
        }
    }
    
    private func fetchMorePlacesAndPhotos() -> Promise<Void> {
        return firstly {
            PlacesUtil.fetchPlaces()
            }.then { hoods in
                PlacesUtil.fetchPhotosForPlaces(likelihoods: hoods).then{ ($0, hoods) }
            }.then { pics, hoods -> Void in
                self.places = zip(hoods,pics).map{ Place(hood: $0, result: $1) }
        }
    }
   
    //MARK: - TableView Delegate + DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCell(withIdentifier: PlacesCell.reuseId, for: indexPath) as! PlacesCell
        placeCell.initCell(place: places[indexPath.row])
        return placeCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
