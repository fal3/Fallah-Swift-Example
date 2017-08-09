//
//  PlacesCell.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import PureLayout
import PromiseKit

class PlacesCell: UITableViewCell {

    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    
    static var reuseId: String {
        get {
            return "PlacesCell"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        setupPlaceImageView()
        setupTitleLabel()
    }
    
    func initCell(place: Place) {
        self.nameLabel.text = place.hood.place.name
        if place.photo.boolValue == true {
            let imageData = PlacesUtil.fetchPhotoForPlace(placeID: place.hood.place.placeID)
            imageData.then { data in
                self.profileImageView.loadImage(with: data, completionHandler:
                    { (er: Error?) in
                    return
                })
                }.catch(execute: { (er: Error) in
                return self.profileImageView.image = #imageLiteral(resourceName: "defaultImage")
            })
            
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "defaultImage")
        }
    }
    
    func setupPlaceImageView() {
        contentView.addSubview(profileImageView)
        profileImageView.backgroundColor = UIColor.green
        profileImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5.0,
                                                                         left: 5.0,
                                                                         bottom: 5.0,
                                                                         right: 5.0), excludingEdge: .right)
        profileImageView.autoSetDimension(.width, toSize: 100.0)
    }
    
    func setupTitleLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.autoPinEdge(.left, to: .right, of: profileImageView, withOffset: 20.0)
        nameLabel.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
    }

}
