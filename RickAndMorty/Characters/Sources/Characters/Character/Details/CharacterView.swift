import SwiftUI
import DesignKit

struct CharacterView: View {
    let character: Character

    init(_ character: Character) {
        self.character = character
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImageView(url: URL(string: character.image))
                .cornerRadius(16)
            Text(character.name)
                .font(.title)
                .padding()
                .background(.bar)
                .roundedCorner(16, corners: [.topLeft])
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(.mock(id: 2))
    }
}
