import DesignSystem
import UIKit

@objc class JokeTableViewCellViewModel: NSObject {
  private let joke: Joke
  
  @objc init(joke: Joke) {
    self.joke = joke
  }
  
  var jokeText: String { joke.text }
  var jokeIsFavorite: Bool { FavoritesService.shared.isFavorite(jokeWithId: joke.id) }
}

@objc class JokeTableViewCell: UITableViewCell {
  private lazy var jokeTextLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var favoritesButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    button.setImage(UIImage(systemName: "star"), for: .normal)
    button.setImage(UIImage(systemName: "star.fill"), for: .selected)
    button.tintColor = Colors.accentTint
    button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    return button
  }()
  
  @objc var didTapFavoritesButton: (() -> Void)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(jokeTextLabel)
    contentView.addSubview(favoritesButton)
    
    NSLayoutConstraint.activate([
      jokeTextLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      jokeTextLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      jokeTextLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
      
      favoritesButton.leadingAnchor.constraint(equalTo: jokeTextLabel.trailingAnchor),
      favoritesButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      favoritesButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      favoritesButton.widthAnchor.constraint(equalTo: favoritesButton.heightAnchor)
    ])
  }
  
  @objc func update(with jokeText: String, isFavorite: Bool) {
    jokeTextLabel.text = jokeText
    favoritesButton.isSelected = isFavorite
  }
  
  @objc private func toggleFavorite() {
    didTapFavoritesButton?()
  }
}
