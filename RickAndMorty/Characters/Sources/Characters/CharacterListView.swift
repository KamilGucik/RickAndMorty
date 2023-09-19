import SwiftUI

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    let charactersRepository: CharactersRepositoryProtocol

    init(charactersRepository: CharactersRepositoryProtocol = CharactersRepository()) {
        self.charactersRepository = charactersRepository
    }

    func getCharacters() async {
        do {
            self.characters = try await charactersRepository.getCharactersList()
        } catch {
            print(error)
        }
    }
}

public struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()

    public init() {}

    public var body: some View {
        List(viewModel.characters) {
            CharacterView(character: $0)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .task { await viewModel.getCharacters() }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}

