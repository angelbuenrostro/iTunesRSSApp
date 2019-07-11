//
//  MediaTableViewCell.swift
//  iTunesRSSApp
//
//  Created by Angel Buenrostro on 7/10/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var savedImage: UIImage?
    var result: Result? {
        didSet { updateViews() }
    }
    
    // MARK: - Views
    
    let opaqueBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1461928636)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CircularStd-Medium", size: 26)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Main Label"
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CircularStd-Medium", size: 20)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Secondary Label"
        return label
    }()
    
    let kindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "CircularStd-Medium", size: 16)
        label.text = "Kind of media"
        label.textColor = .black
        label.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 0)
        return label
    }()
    
    let mediaImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let backgroundBlurImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        self.hero.isEnabled = true
        // Adds media image to the background with a blur effect on top
        self.backgroundView = backgroundBlurImage
        backgroundBlurImage.contentMode = .scaleAspectFill
        backgroundBlurImage.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        backgroundView?.addSubview(blurView)
        blurView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Cell resetting for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundBlurImage.image = nil
        mediaImage.image = nil
    }
    
    
    
    func setupViews(){
        let marginsGuide = contentView.layoutMarginsGuide
        
        // Add an opaque background layer
        
        contentView.addSubview(opaqueBackground)
        
        // Add labels to contentView so that constraints may be added
        contentView.addSubview(mainLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(kindLabel)
        
        // Set anchors for dynamic sizing of cell
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor, constant: -120).isActive = true
        
        // Set anchors for dynamic sizing of cell
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor).isActive = true
        secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        secondaryLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor).isActive = true
        
        // Set anchors for dynamic sizing of cell
        kindLabel.translatesAutoresizingMaskIntoConstraints = false
        kindLabel.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 18).isActive = true
        kindLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor).isActive = true
        kindLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor).isActive = true
        kindLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor).isActive = true
        
        // Add image to contentView so that constraints may be added
        contentView.addSubview(mediaImage)
        
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor).isActive = true
        mediaImage.constrainHeight(constant: 100)
        mediaImage.constrainWidth(constant: 100)
        mediaImage.centerYInSuperview()
        
        mediaImage.hero.id = "mediaImage"
        
        // Add constraints to opaque background
        opaqueBackground.translatesAutoresizingMaskIntoConstraints = false
        opaqueBackground.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor).isActive = true
        opaqueBackground.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        opaqueBackground.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor).isActive = true
        opaqueBackground.bottomAnchor.constraint(equalTo: kindLabel.bottomAnchor).isActive = true
        
    }
    
    func updateViews(){
        // Updates UI with appropriate data information if result is available
        guard let result = result else { return }
        
        guard let artURL = URL(string: result.artworkUrl100) else { return }
        loadImageIntoMultipleViews(url: artURL, imageViews: [mediaImage, backgroundBlurImage])
        
        
        switch result.kind {
        case "album":
            kindLabel.text = "Album"
        case "book":
            kindLabel.text = "Audio Book"
        case "tvEpisode":
            kindLabel.text = "TV Show"
        default: break
        }
        
        mainLabel.text = result.name
        secondaryLabel.text = result.artistName
        
    }
    
    func loadImageIntoMultipleViews(url: URL, imageViews: [UIImageView]){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        for view in imageViews{
                            self?.savedImage = image
                            self?.result!.image = image
                            view.image = image
                        }
                    }
                }
            }
        }
    }
}
