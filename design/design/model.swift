
import Foundation
import UIKit

struct MovieWebData: Codable {
    var results: [Results]
}

struct Results: Codable {
    var title: String
    var release_date: String
    var poster_path: String
    
}
struct MovieModel {
    var title: [String]
    var release_date: [String]
    var poster_path: [String]
    
}
let api_key = "05c3e9282c9c3b669a5d16a46903119a"
let language = "en-US"
let page = "1"
let base_url = "https://image.tmdb.org/t/p/original"
let movieUrl = "https://api.themoviedb.org/3/movie/"


protocol UpdateMoviesDelegate {
    func didUpdateMovie(_ movieManager:MovieManager,movie: MovieModel)
    
}
struct MovieManager {
    
    var delegate: UpdateMoviesDelegate?
    
    func fetchMovie(movieList: String) {
        let urlString = "\(movieUrl)\(movieList)?api_key=\(api_key)&language=\(language)&page=1"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            } else {
                if let dataResponse = data {
                    if let movie = self.parseJson(movieData: dataResponse) {
                        self.delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
        }
        task.resume()
    
    }
    func parseJson(movieData: Data) -> MovieModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(MovieWebData.self, from: movieData)
            var movieTitle =  [String]()
            var movieDate = [String]()
            var moviePoster = [String]()
        
            for result in decoderData.results {

                movieTitle.append(result.title)
                movieDate.append(result.release_date)
                moviePoster.append(result.poster_path)

            }
            let movie = MovieModel(title: movieTitle, release_date: movieDate, poster_path: moviePoster)
            return movie
        } catch {
            print("Error")
            return nil
        }
    }
}
var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func load(urlString: String){
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}

