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
            .tabItem { Text("Characters").font(.headline) }
            NavigationView {
                EpisodeListView()
                    .navigationTitle("Episodes")
            }
            .tabItem { Text("Episodes").font(.headline) }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
