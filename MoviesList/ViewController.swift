import UIKit

class ViewController: UIViewController {

    // Todo
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let moviesList = MoviesListClass()
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    private var currentSortType: SortType?
    private var isAscending = true
    // MARK: - Public Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        view.backgroundColor = .black
        
        // Todo
        setInit()
        callToGetMovieList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Movie List"
        navigationController?.navigationBar.titleTextAttributes = [
             .foregroundColor: UIColor.white
         ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradient = view.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = view.bounds
        }
    }
    
    // MARK: - Private Method
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        // Define your colors (you can adjust the shades as needed)
        gradientLayer.colors = [
              UIColor(red: 10/255, green: 20/255, blue: 40/255, alpha: 1).cgColor, // Navy Blue
              UIColor.black.cgColor
          ]

      
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0) 

        // Insert the gradient below all subviews
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setInit() {
        // Todo
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "movie-list"
        tableView.backgroundColor = .clear
        searchBar.delegate = self
        searchBar.accessibilityIdentifier = "search-input"
        
        tableView.register(
            UINib(nibName: "MovieListCell", bundle: nil),
            forCellReuseIdentifier: "MovieListCell"
        )

        setupActivityIndicator()
        self.sortButton.titleLabel?.font = UIFont(name: Fonts.satoshiMedium.fontName, size: 13)
        self.reloadButton.titleLabel?.font = UIFont(name: Fonts.satoshiMedium.fontName, size: 13)
        self.filterButton.titleLabel?.font = UIFont(name: Fonts.satoshiMedium.fontName, size: 13)
        self.sortButton.layer.cornerRadius = 8
        self.filterButton.layer.cornerRadius = 8
        self.reloadButton.layer.cornerRadius = 8
        self.sortButton.layer.borderWidth = 1
        self.reloadButton.layer.borderWidth = 1
        self.filterButton.layer.borderWidth = 1
        self.sortButton.layer.borderColor = UIColor.lightGray.cgColor
        self.reloadButton.layer.borderColor = UIColor.lightGray.cgColor
        self.filterButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func setupActivityIndicator() {
        // Todo
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
    }
    
    private func showLoader() {
        // Todo
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func removeLoader() {
        // Todo
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - API Call Method
    func callToGetMovieList() {
        // Todo
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        showLoader()
        
        ApiService.shared.fetchMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            self.removeLoader()
            
            switch result {
            case .success(let response):
                self.totalPages = response.totalPages
                self.currentPage += 1
                self.moviesList.appendMovies(response.data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure:
                break
            }
        }
    }
    private func toggleSort(by type: SortType) {
        if currentSortType == type {
            // Same sort tapped again → toggle order
            isAscending.toggle()
        } else {
            // New sort → reset to ascending
            currentSortType = type
            isAscending = true
        }
        
        moviesList.sort(by: type == .name ? .name : .year,
                        ascending: isAscending)

        tableView.reloadData()
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        toggleSort(by: .name)
        self.sortButton.setImage(isAscending ? UIImage(named: "ic_up") : UIImage(named: "ic_down"), for: .normal)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        toggleSort(by: .year)
        self.filterButton.setImage(isAscending ? UIImage(named: "ic_up") : UIImage(named: "ic_down"), for: .normal)
    }
    @IBAction func reloadButtonAction(_ sender: Any) {
        moviesList.clearSort()
        
        currentSortType = nil
        isAscending = true
        self.filterButton.setImage(isAscending ? UIImage(named: "ic_up") : UIImage(named: "ic_down"), for: .normal)
        self.sortButton.setImage(isAscending ? UIImage(named: "ic_up") : UIImage(named: "ic_down"), for: .normal)
        tableView.reloadData()
    }
    
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesList.filteredMovies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieListCell",
            for: indexPath
        ) as! MovieListCell

        let movie = moviesList.filteredMovies[indexPath.row]
        cell.configure(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            callToGetMovieList()
        }
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviesList.search(text: searchText)
        tableView.reloadData()
    }
}

