import Foundation

class MoviesListClass {

    private(set) var allMovies: [MovieList] = []
    private(set) var filteredMovies: [MovieList] = []

    func appendMovies(_ movies: [MovieList]) {
        allMovies.append(contentsOf: movies)
        filteredMovies = allMovies
    }

    func search(text: String) {
        if text.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter {
                $0.title.lowercased().contains(text.lowercased())
            }
        }
    }

    enum SortType {
        case name
        case year
    }

    func sort(by type: SortType, ascending: Bool) {
        switch type {
        case .name:
            filteredMovies.sort {
                ascending ? $0.title < $1.title : $0.title > $1.title
            }
        case .year:
            filteredMovies.sort {
                ascending ? $0.year < $1.year : $0.year > $1.year
            }
        }
    }

    func clearSort() {
        filteredMovies = allMovies
    }
}

