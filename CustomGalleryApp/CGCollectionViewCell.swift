//
//  CGCollectionViewCell.swift
//  CustomGalleryApp
//
//  Created by Saravanakumar on 05/06/18.
//  Copyright © 2018 Saravanakumar. All rights reserved.
//

import UIKit

class CGCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView : UIImageView!
    
    var assetIdentifier:String!
    
    var showImage : UIImage! {
        didSet{
            imageView.image = showImage
        }
    }

}
