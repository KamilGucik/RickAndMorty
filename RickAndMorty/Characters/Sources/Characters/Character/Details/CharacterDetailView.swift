import SwiftUI
import DesignKit

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel

    init(_ character: Character) {
        self._viewModel = .init(wrappedValue: .init(character: character))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImageView(url: .init(string: viewModel.character.image))
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(16)
                Text(viewModel.character.name)
                    .font(.title)
                    .lineLimit(nil)
                VStack(alignment: .leading, spacing: 4) {
                    textLabel(title: "Status", text: viewModel.character.status.rawValue)
                    textLabel(title: "Species", text: viewModel.character.species)
                    if let type = viewModel.character.type, !type.isEmpty {
                        textLabel(title: "Type", text: type)
                    }
                    textLabel(title: "Gender", text: viewModel.character.gender.rawValue)
                    textLabel(title: "Location", text: viewModel.character.location.name)
                }
                charactersInLocation
                Spacer()
            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favouriteButton
            }
        }
        .onAppear { viewModel.checkIfIsFavourite() }
        .task { await viewModel.fetchCharactersInLocation() }
    }

    private var favouriteButton: some View {
        Button(
            action: { viewModel.tapFavourite() },
            label: {
                Image(.heart(filled: viewModel.isCharacterFavourite))
                    .foregroundColor(.red)
            }
        )
    }

    private var charactersInLocation: some View {
        VStack(alignment: .leading) {
            Text("Other characters in location")
                .font(.body)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.charactersInLocation) { character in
                        ZStack(alignment: .bottom) {
                            AsyncImageView(url: .init(string: character.image))
                                .aspectRatio(contentMode: .fit)
                            Text(character.name)
                                .lineLimit(nil)
                                .padding(4)
                                .background(.bar)
                                .cornerRadius(16)
                                .padding(4)
                        }
                        .frame(width: 150, height: 150)
                        .cornerRadius(16)
                    }
                }
            }
        }
        .loadable(
            isLoading: $viewModel.isLoading,
            showError: $viewModel.showError,
            refreshAction: { await viewModel.fetchCharactersInLocation() }
        )
    }

    private func textLabel(title: String, text: String) -> some View {
        HStack {
            Text(title + ":")
                .fontWeight(.light)
            Text(text)
                .bold()
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(.mockList(size: 1)[0])
    }
}
