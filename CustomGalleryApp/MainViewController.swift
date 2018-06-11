//
//  MainViewController.swift
//  CustomGalleryApp
//
//  Created by Saravanakumar on 05/06/18.
//  Copyright © 2018 Saravanakumar. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {

    @IBOutlet var openPhotos:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openPhotos.layer.masksToBounds = true
        openPhotos.layer.cornerRadius = 5.0
    }
    
    @IBAction func openPhotosTapped() {
        PHPhotoLibrary.requestAuthorization { (status) in
            
            var isDenied : Bool = true
            
            switch status {
            case .authorized:
                isDenied = false
            case .notDetermined:
                isDenied = true
            case .denied:
                isDenied = true
            case .restricted:
                isDenied = true
            }
            
            if isDenied {
                UIView.animate(withDuration: 0.5, animations: {
                    UIAlertController.showAlert(withTitle: "Alert", message: photosDeniedMessage)
                })
            }
            else {
                DispatchQueue.main.sync {
                    let customGalleryVC:CustomGalleryViewController = CustomGalleryViewController.fromStoryboard(withIdentifier: "CustomGalleryViewController")
                    let nav = UINavigationController(rootViewController: customGalleryVC)
                    
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
}



