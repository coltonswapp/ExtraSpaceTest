//
//  ViewController.swift
//  ExtraSpaceTest
//
//  Created by Colton Swapp on 8/24/21.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    // Bonus points for refresh :)
    var refresh: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    // Mark the location at which we will start fetching items.
    var currentAlbumSpot = 0
    
    func configure() {
        
        refresh.attributedTitle = NSAttributedString(string: "Pull down to see to refresh albums!")
        refresh.addTarget(self, action: #selector(getAlbums(_:)), for: .valueChanged)
        tableView.addSubview(refresh)
        
        getAlbums(0)
    }
    
    // Get albums is called when the view loads, as well as when we get to the bottom of the tableview to fetch the next 10 albums.
    @objc func getAlbums(_ start: Int) {
        
        AlbumController.shared.fetchAlbums(start: start, limit: 10) { result in
            
            // Head back to the main thread to update the user interface.
            DispatchQueue.main.async {
                // Switch on the result of our network call.
                switch result {
                
                // If we suceed, do this:
                case .success(_):
                    self.refresh.endRefreshing()
                    print("Houston we have toched down with the API")
                    // Adjust the currentAlbumSpot to reflect where we are in the data.
                    self.currentAlbumSpot = start
                    // Reload tableview with newly fetched data.
                    self.tableView.reloadData()
                    
                // If we fail, do this:
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows in the tableview will be however many albums are in our source of truth.
        AlbumController.shared.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell and cast as our custom cell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        
        // Capture which album this will be, using the indexPath
        let album = AlbumController.shared.albums[indexPath.row]
        
        // Pass the album to the cell so it can update itself accordingly.
        cell.album = album
        
        // return the cell.
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Use these to calculate when we have reached the bottom
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // Once we stop decelerating, and are at the bottom of the tableview, get 10 more albums.
            getAlbums(currentAlbumSpot + 10)
        }
    }

    // Bonus points for navigation to detail view :)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let index = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? AlbumDetailViewController else { return }
            
            let albumToSend = AlbumController.shared.albums[index.row]
            destination.album = albumToSend
        }
    }
}

