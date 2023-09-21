import SwiftUI
import DesignKit

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImageView(url: .init(string: character.image))
                .cornerRadius(16)
            Text(character.name)
                .font(.title)
                .lineLimit(nil)
            VStack(alignment: .leading, spacing: 4) {
                textLabel(title: "Status", text: character.status.rawValue)
                textLabel(title: "Species", text: character.species)
                if let type = character.type, !type.isEmpty {
                    textLabel(title: "Type", text: type)
                }
                textLabel(title: "Gender", text: character.gender.rawValue)
                textLabel(title: "Location", text: character.location.name)
            }
            Spacer()
        }
        .padding(24)
        .navigationBarTitleDisplayMode(.inline)
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
        CharacterDetailView(character: Character.mockList(size: 1)[0])
    }
}
