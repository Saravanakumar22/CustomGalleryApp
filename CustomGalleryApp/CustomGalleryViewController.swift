//
//  CustomGalleryViewController.swift
//  CustomGalleryApp
//
//  Created by Saravanakumar on 05/06/18.
//  Copyright © 2018 Saravanakumar. All rights reserved.
//

import UIKit
import Photos

let photosDeniedMessage = "Please allow Photos access to display your photos"

class CustomGalleryViewController: UIViewController {

    @IBOutlet var collectionView : UICollectionView!
    
    fileprivate var fetchResult:PHFetchResult<PHAsset>? = PHFetchResult<PHAsset>()
    fileprivate var imageSize : CGSize!
    fileprivate var imageManager:PHCachingImageManager? = PHCachingImageManager()
    fileprivate var selectedAssets = [PHAsset]()
    fileprivate var gridType : CGFloat = 3.0
    
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = []
        self.title = "Photos"
        //Registering Cell
        collectionView.register(UINib(nibName: "CGCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CGCollectionViewCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(self.gridPressed))

        fetchPHAssetFromLibrary()
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
    }
    
    fileprivate func scrollToBottom() {
        let collectionViewHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionViewHeight+11, width: 1, height: 1), animated: true)
        collectionView.scrollToItem(at: IndexPath(item: fetchResult!.count-1, section: 0), at: .bottom, animated: true)
    }
    
    deinit {
        imageManager = nil
        fetchResult = nil
        print("Deinit : CustomGalleryViewController")
    }
    
    @objc fileprivate func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func gridPressed() {
        showActionSheet()
    }
    
    fileprivate func fetchPHAssetFromLibrary() {
        
        let scale = UIScreen.main.scale
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        imageSize = CGSize(width: cellSize.width*scale, height: cellSize.height*scale)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    fileprivate func reloadCollectionView(value:CGFloat) {
        self.gridType = value
        self.collectionView.reloadData()
        self.scrollToBottom()
    }
    
    fileprivate func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: gridType == 4 ? "‣ 4x4" : "4x4", style: .default, handler: { (_) in
            self.reloadCollectionView(value: 4.0)
        }))
        alertController.addAction(UIAlertAction(title: gridType == 3 ? "‣ 3x3" : "3x3", style: .default, handler: { (_) in
            self.reloadCollectionView(value: 3.0)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func addBottomConstraintForCollectionView() {
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            
            guide.bottomAnchor.constraintEqualToSystemSpacingBelow(collectionView.bottomAnchor, multiplier: 1.0).isActive = true
        }
        else {
            self.bottomLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        }
    }
    
}


extension CustomGalleryViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CGCollectionViewCell", for: indexPath) as! CGCollectionViewCell
        
        let asset = fetchResult![indexPath.item]
        cell.assetIdentifier = asset.localIdentifier

        imageManager!.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: nil) { (image, _) in
            //Set image only if both identifiers are same
            if cell.assetIdentifier == asset.localIdentifier {
                cell.showImage = image
            }
        }
        return cell
    }
}

extension CustomGalleryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/gridType, height: collectionView.frame.width/gridType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIViewController {
    
    static func fromStoryboard<T>(withIdentifier identifier:String) -> T {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension UIAlertController {
    
    class func showAlert(withTitle title:String?, message:String) {
        
        let alertController = UIAlertController(title: title != nil ? title : nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        let baseController = UIApplication.shared.keyWindow?.rootViewController
        baseController!.present(alertController, animated: true, completion: nil)
        
    }
}




