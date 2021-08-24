//
//  AlbumController.swift
//  ExtraSpaceTest
//
//  Created by Colton Swapp on 8/24/21.
//

import UIKit

class AlbumController {
    
    // MARK: - SHARED INSTANCE
    // Singleton pattern used to only create one instance of AlbumController in memory - going to be used by several different files to access the shared resources that live on this controller.
    static let shared = AlbumController()
    
    // MARK: - Source of Truth
    // All fetched albums will be appended and stored here.
    var albums: [Album] = []
    
    // MARK: - Cache
    // Cache will be used to limit the amount of fetching that is done to get the images for the albums.
    static let cache = NSCache<NSString, UIImage>()
    
    // Endpoint and component stored here for easy reuse.
    var baseURL = "https://jsonplaceholder.typicode.com/"
    var photosComponent = "photos"
    
    // Normally I would write constructURL() inside of the fetchAlbums() function, but having them separate allows me to run a unit test on constructing the URL.
    func constructURL(start: Int, limit: Int) -> URL? {
        
        // Append the photos component
        guard let url = URL(string: baseURL)?.appendingPathComponent(photosComponent) else { return nil }
        
        // Create a URLComponents object from our baseURL
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // Create 2 URLQueryItems to assist with pagination.
        let startQuery = URLQueryItem(name: "_start", value: String(start))
        let limitQuery = URLQueryItem(name: "_limit", value: String(limit))
        
        components?.queryItems = [startQuery, limitQuery]
        
        // Generate a finalURL courtesy of the URLComponents
        guard let finalURL = components?.url else { return nil }
        
        // Return that finalURL
        return finalURL
    }
    
    // The main fetch function, using result type. Success means an array of albums, and failure is some kind of NetworkError of my choosing depending on where I call failure()
    func fetchAlbums(start: Int, limit: Int, completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        
        // Capture the finalURL from the constructURL method
        guard let finalURL = constructURL(start: start, limit: limit) else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        // Start a data task using that URL, and label the parts of the completion handler.
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            // Handle error, if any
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            // Use response for debugging purposes. I was getting a 503 code (Not in service) on Monday, which was very helpful for debugging.
            if let response = response as? HTTPURLResponse {
                print("Call status code: \(response.statusCode)")
                if response.statusCode != 200 {
                    return completion(.failure(.unknownIssue))
                }
            }
            
            // Confirm that we actually have data.
            guard let data = data else { return completion(.failure(.noData)) }
            
            // Attempt to decode the data using JSONDecoder().
            // Since the decode() function throws, we must place in a do-catch block.
            do {
                let albums = try JSONDecoder().decode([Album].self, from: data)
                // this will append each item to the SourceOfTruth array, in order.
                for album in albums {
                    self.albums.append(album)
                }
                // Completion success :)
                completion(.success(albums))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            // Don't forget to resume the datatask.
        }.resume()
        
    }
    
}
