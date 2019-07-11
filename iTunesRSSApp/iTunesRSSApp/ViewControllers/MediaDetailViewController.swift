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
    
    lazy var mediaImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.titleView = nil
        self.hero.isEnabled = true
        mediaImage.hero.id = "mediaImage"
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(mediaImage)
        mediaImage.fillSuperview()
        mediaImage.image = savedImage
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
