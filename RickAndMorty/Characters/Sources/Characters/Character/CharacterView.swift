import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    enum State {
        case loading
        case failure
        case loaded(Data)
    }
    @Published var state: State = .loading

    func load(url: URL) async {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.state = .loaded(cachedResponse.data)
            return
        }

        do {
            self.state = .loading
            let (data, _) = try await URLSession.shared.data(from: url)
            self.state = .loaded(data)
        } catch {
            self.state = .failure
        }
    }
}

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: URL

    var body: some View {
        Group {
            switch imageLoader.state {
            case .loading:
                ProgressView()
            case .loaded(let imageData):
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            case .failure:
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
        .task { await imageLoader.load(url: url) }
    }
}

struct CharacterView: View {
    let character: Character

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImageView(url: URL(string: character.image)!)
                .cornerRadius(16)
            Text(character.name)
                .font(.title)
                .padding()
                .background(.bar)
                .roundedCorner(16, corners: [.topLeft])
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        let character = Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
            location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            url: "https://rickandmortyapi.com/api/character/2",
            created: "2017-11-04T18:50:21.651Z"
        )

        CharacterView(character: character)
    }
}
