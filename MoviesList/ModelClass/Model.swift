import Foundation

struct ResponseClass: Codable {
    // TODO
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [MovieList]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}

struct MovieList: Codable {
    // TODO
    let id: String
    let title: String
    let year: Int
    let type: String?
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
