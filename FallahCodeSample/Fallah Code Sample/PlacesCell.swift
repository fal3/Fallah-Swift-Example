//
//  PlacesCell.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import PureLayout

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
        self.nameLabel.text = place.title
        self.profileImageView.loadImage(with: place.photo) { (error: Error?) in
            guard let _ = error else {
                return
            }
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
        nameLabel.text = "The Voice"
    }

}
