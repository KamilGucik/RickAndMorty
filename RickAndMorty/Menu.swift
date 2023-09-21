import SwiftUI
import Episodes
import Characters

struct Menu: View {
    var body: some View {
        TabView {
            NavigationView {
                CharacterListView()
                    .navigationTitle("Characters")
            }
            .tabItem { Label("Characters", systemImage: "person.crop.circle") }
            NavigationView {
                EpisodeListView()
                    .navigationTitle("Episodes")
            }
            .tabItem { Label("Episodes", systemImage: "tv") }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
