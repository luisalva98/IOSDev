//
//  MovieViewController.swift
//  Flixpart1
//
//  Created by Luis Alva on 9/16/19.
//  Copyright © 2019 Luis Alva. All rights reserved.
//

import UIKit
import AlamofireImage
class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var TableView: UITableView!
    var movies = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = (dataDictionary)["results"] as! [[String:Any]]
                self.TableView.reloadData()
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "MovieCellTableViewCell") as! MovieCellTableViewCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let description = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)
        
//        cell.textLabel!.text = title
        cell.movieTitle.text = title
        cell.movieDescription.text = description
        cell.imageView!.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexpath = TableView.indexPath(for: cell)!
        let movie = movies[indexpath.row]
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        TableView.deselectRow(at: indexpath, animated: true)
    }


}
