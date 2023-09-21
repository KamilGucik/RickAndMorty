import SwiftUI
import Episodes
import Characters
import DesignKit

struct Menu: View {
    var body: some View {
        TabView {
            NavigationView {
                CharacterListView()
                    .navigationTitle("Characters")
            }
            .tabItem { Label("Characters", image: .characters) }
            NavigationView {
                EpisodeListView()
                    .navigationTitle("Episodes")
            }
            .tabItem { Label("Episodes", image: .episodes) }
            NavigationView {
                FavouritesListView()
                    .navigationTitle("Favourites")
            }
            .tabItem { Label("Favourites", image: .favourites) }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
