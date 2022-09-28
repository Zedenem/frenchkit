import DesignSystem
import SwiftUI

struct FavoritesView: View {
  @ObservedObject var viewModel: FavoritesViewModel
  
  init(viewModel: FavoritesViewModel = FavoritesViewModel(favoritesService: FavoritesService.shared)) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    if viewModel.favorites.count == 0 {
      emptyMessage
    } else {
      favoritesList
    }
  }
  
  var favoritesList: some View {
    List {
      ForEach(Array(viewModel.favorites.enumerated()), id: \.element.id) { index, joke in
        HStack {
          Text(joke.text)
            .listRowBackground( Color((index % 2 == 0) ? Colors.listItemEvenBackground : UIColor.listItemOddBackground))
          Spacer()
          Button(action: {
            viewModel.jokeToRemoveFromFavorite = joke
          }) {
            Image(systemName: "star.fill")
              .foregroundColor(Color(Colors.accentTint))
          }
        }
      }
    }
    .listStyle(.plain)
    .alert(item: $viewModel.jokeToRemoveFromFavorite) { joke in
      Alert(title: Text("Remove from favorites?"),
            message: nil,
            primaryButton: .destructive(Text("Yes")) { viewModel.removeFromFavorites(joke: joke) },
            secondaryButton: .cancel())
    }
  }
  
  var emptyMessage: some View {
    Text("You have no favorites")
  }
}

struct FavoritesView_Previews: PreviewProvider {
  struct PreviewFavoritesService: FavoritesServicing {
    func isFavorite(jokeWithId: String) -> Bool { true }
    func addToFavorites(joke: Joke) throws {}
    func removeFromFavorites(joke: Joke) throws {}
    var allFavorites: [Joke] = [
      Joke(id: "1", text: "A joke"),
      Joke(id: "2", text: "Another way longer joke with a pun at the end. That wasn't the end. Pun."),
      Joke(id: "3", text: "A joke"),
    ]
  }
  
  static var previews: some View {
    FavoritesView(viewModel: FavoritesViewModel(favoritesService: PreviewFavoritesService()))
  }
}
