//
//  AlbumDetailViewController.swift
//  ExtraSpaceTest
//
//  Created by Colton Swapp on 8/24/21.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var albumThumbnailImageView: UIImageView!
    @IBOutlet weak var albumIDLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // Reference the cache for grabbing images that already live there.
    let cache = AlbumController.cache
    // Landing pad for navigation purposes.
    var album: Album?
    
    // Configure our UI elements accordingly.
    func updateViews() {
        guard let album = album else { return }
        // Grab the image from the cache.
        albumThumbnailImageView.image = cache.object(forKey: NSString(string: album.thumbnailUrl))
        albumThumbnailImageView.layer.cornerRadius = 5
        albumIDLabel.text = "ID: \(album.id)"
        albumTitleLabel.text = album.title
    }
}
