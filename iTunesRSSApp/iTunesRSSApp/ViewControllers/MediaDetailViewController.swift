//
//  MediaDetailViewController.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {
    
    var result: Result? {
        didSet{
            updateViews()
        }
    }
    
    var savedImage: UIImage?
    
    let opaqueBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.695895493)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    lazy var mediaImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.titleView = nil
        self.hero.isEnabled = true
        mediaImage.hero.id = "mediaImage"
        opaqueBackground.hero.id = "opaqueBackground"
        
        setupViews()
    }
    
    func setupViews() {
        // Add views
        view.addSubview(mediaImage)
        view.addSubview(opaqueBackground)
        // Set image
        mediaImage.image = savedImage
        // Make constraints for dynamic resizing
        let safeArea = view.safeAreaLayoutGuide
        
        // Make media image cover safe area
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        mediaImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        mediaImage.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        mediaImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        opaqueBackground.translatesAutoresizingMaskIntoConstraints = false
        opaqueBackground.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12).isActive = true
        opaqueBackground.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12).isActive = true
        opaqueBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        opaqueBackground.constrainHeight(constant: view.frame.height/5)
        opaqueBackground.centerXInSuperview()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews(){
        mediaImage.image = self.savedImage
        mediaImage.contentMode = .scaleAspectFill
    }
    

}
