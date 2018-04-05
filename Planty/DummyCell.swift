//
//  DummyCell.swift
//  Planty
//
//  Created by Gunapandian on 04/04/18.
//  Copyright © 2018 Gunapandian. All rights reserved.
//

import UIKit

class DummyCell: UICollectionViewCell {
    
    @IBOutlet var BGImageView: UIImageView!
    
    func setImage(image : UIImage){
        BGImageView.image = image
    }
}
