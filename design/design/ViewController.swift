//
//  ViewController.swift
//  design
//
//  Created by ekincare on 05/10/21.
//

import UIKit

class ViewController: UIViewController {

    var movieManager = MovieManager()
    var movieModel : MovieModel?
    var movTitle = [String]()
    var movDate = [String]()
    var movPath = [String]()
    var imgArray = [String]()
    var mov = [Results]()

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableview.register(cell.nib(), forCellReuseIdentifier: cell.identifier)
        tableview.delegate = self
        tableview.dataSource = self
        movieManager.delegate = self
        movieModel = MovieModel(title: movTitle, release_date: movDate, poster_path: movPath)
        
    }

    @IBAction func segment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let movie = sender.titleForSegment(at: 0) {
                movieManager.fetchMovie(movieList: movie)
            }
        case 1:
            if let movie = sender.titleForSegment(at: 1) {
                movieManager.fetchMovie(movieList: movie)
            }
        default:
            break
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as? cell{
            cell.configure(title: movTitle[indexPath.row], reldate: movDate[indexPath.row], img: imgArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
}
extension ViewController : UpdateMoviesDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel) {
        DispatchQueue.main.async {
            self.movTitle = movie.title
            self.movDate = movie.release_date
            self.movPath = movie.poster_path
            for path in self.movPath {
                let urlString = "\(base_url)\(path)"
                self.imgArray.append(urlString)
            }
            self.tableview.reloadData()
        }
    }
}
