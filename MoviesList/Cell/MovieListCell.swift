import UIKit

class MovieListCell: UITableViewCell {

    // TODO
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupCardStyle()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Space between cells
        let inset: CGFloat = 5
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCardStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupUI() {
            nameLabel.font = .appFont(size: 14, fontName: .satoshiBold)
            yearLabel.font = .appFont(size: 12, fontName: .satoshiRegular)
            imdbLabel.font = .appFont(size: 12, fontName: .satoshiRegular)

            nameLabel.numberOfLines = 2
    }
    
    // TODO
    func configure(movie: MovieList) {
        nameLabel.text = movie.title
        yearLabel.text = "Year: \(movie.year)"
        imdbLabel.text = "ID: \(movie.id)"
    }
    
}
