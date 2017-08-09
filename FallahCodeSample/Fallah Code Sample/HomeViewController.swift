//
//  ViewController.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import PromiseKit

class HomeViewController: UITableViewController {

    private var hoods: [GMSPlaceLikelihood]!
    private var photos: [GMSPlacePhotoMetadata]!
    private var places: [Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlacesCell.self, forCellReuseIdentifier: PlacesCell.reuseId)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//      refreshLocation()
        runAll()
    }
    
    // MARK: - Helper Methods
    private func initPlaces() -> Promise<[Place]> {
        return Promise { fulfill, reject in
            var places = [Promise<Place>]()
            for i in 0..<hoods.count {
                places.append(Promise(value: Place(with: hoods[i].place.name, pic: photos[i])))
            }
            when(fulfilled: places).then { ps in
                fulfill(ps)
                }.catch { error in
                    reject(error)
            }
        }
    }
    
    private func fetchPlacesAndPhotos() -> Promise<Void> {
        return Promise { fulfill, reject in
            firstly {
                // 1.Fetch Likelihoods
                   PlacesUtil.fetchPlaces()
                }.then { ps in
                    self.hoods = ps
                }.catch { er in
                    self.showAlert(title: "Error", msg: er.localizedDescription)
                }
            .then {
                PlacesUtil.fetchPhotosForPlaces(likelihoods: self.hoods)
            }.then { pics in
                self.photos = pics
            }.then {
                fulfill()
            }.catch { er in
                self.showAlert(title: "Error", msg: er.localizedDescription)
            }
        }
    }
    
    private func runAll() {
        when(fulfilled: fetchPlacesAndPhotos()).then {
            self.initPlaces()
            }.then { places in
                self.places = places
        }
    }
    
    private func fetchPlaces() -> Promise<Void> {
        return Promise { fulfill, reject in
            firstly {
                PlacesUtil.fetchPlaces() // Fetch Places From Google Places API
                }.then { hoods in
                    self.hoods = hoods
                }.then {
                    PlacesUtil.fetchPhotosForPlaces(likelihoods: self.hoods) // Fetch Photos from google places
                }.then { pics in
                    self.photos = pics
                }.then {
                    fulfill()
                }.catch { error in
                    reject(error)
                }
        }
    }
    
    private func refreshLocation() {
        //Check if user allowed location permission
        if LocationUtil.didAllowLocation {
            when(fulfilled: fetchPlaces()).then {
                    self.initPlaces()
                }.then { places in
                    return self.places = places
                }.then {
                    self.tableView.reloadData()
                }.catch { error in
                    self.showAlert(title: "Error", msg: error.localizedDescription)
            }
        } else {
            // Prompt user for permission
            LocationUtil.getPermission(containingVC: self)
        }
        
    }
    
    func doShit() {
        firstly {
            PlacesUtil.fetchPlaces().then { hoods in
                self.hoods = hoods
                }.then {
                    PlacesUtil.fetchPhotosForPlaces(likelihoods: self.hoods) // Fetch Photos from google places
                }.then { pics in
                    self.photos = pics
                }.then {
                    self.initPlaces()
                }.then { places in
                    self.places = places
                }.catch { error in
            }// Fetch Places From Google Places API
            }.then {
                self.tableView.reloadData()
            }.catch { error in
        }
    }
    
    //MARK: - TableView Delegate + DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCell(withIdentifier: PlacesCell.reuseId, for: indexPath) as! PlacesCell
        guard let pcs = places else {
            return UITableViewCell()
        }
        
        placeCell.initCell(place: pcs[indexPath.row])
        
        return placeCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pcs = places else {
            return 0
        }
        return pcs.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}

