import Foundation
import UIKit

class ApiService {

    static let shared = ApiService()
    private init() {}

    private let baseURL = "https://jsonmock.hackerrank.com/api/moviesdata"

    func fetchMovies(page: Int, completion: @escaping (Result<ResponseClass, Error>) -> Void) {

        guard let url = URL(string: "\(baseURL)?page=\(page)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(ResponseClass.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

