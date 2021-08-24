//
//  AlbumTableViewCell.swift
//  ExtraSpaceTest
//
//  Created by Colton Swapp on 8/24/21.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumIDLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    // Easily reference the cache
    let cache = AlbumController.cache
    
    // Landing pad for setting up our cell.
    var album: Album? {
        // Use a didSet observer so that when the cell has an album assigned to it, it can configure itself.
        didSet {
            updateViews()
            layoutIfNeeded()
        }
    }
    
    // Configure UI elements on the cell.
    func updateViews() {
        guard let album = album else { return }
        downloadImage(from: album.thumbnailUrl)
        thumbnailImageView.layer.cornerRadius = 5
        albumIDLabel.text = "ID: \(album.id)"
        albumTitleLabel.text = album.title
    }
    
    // 2 things happening in here.
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        
        // 1: If the image is already in the cache, set that image to the thumbnailImageView
        if let image = cache.object(forKey: cacheKey) {
            self.thumbnailImageView.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        // 2: If the image is not in the cache, use the thumbnailUrl property to fetch it and put it in the cache.
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            // Set object in cache.
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
            
        }.resume()
    }

}
