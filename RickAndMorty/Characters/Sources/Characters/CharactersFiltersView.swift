import SwiftUI
import DesignKit

struct CharactersFiltersView: View {
    @Binding var filters: CharacterFilterParameters

    init(filters: Binding<CharacterFilterParameters>) {
        self._filters = filters
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            textFields
            GroupBox {
                statusPicker
                genderPicker
            }
            Spacer()
        }
        .padding(24)
    }

    private var textFields: some View {
        GroupBox {
            VStack(spacing: 16) {
                TextField("Name", text: $filters.name)
                TextField("Species", text: $filters.species)
                TextField("Type", text: $filters.type)
            }
        }
    }

    private var statusPicker: some View {
        HStack {
            Text("Status")
            Spacer()
            Picker("Status", selection: $filters.status) {
                Text("None").tag(nil as Character.Status?)
                ForEach(Character.Status.allCases) { status in
                    Text(status.rawValue.capitalized)
                        .tag(Optional(status))
                }
            }
        }
    }

    private var genderPicker: some View {
        HStack {
            Text("Gender")
            Spacer()
            Picker("Gender", selection: $filters.gender) {
                Text("None").tag(nil as Character.Gender?)
                ForEach(Character.Gender.allCases) { gender in
                    Text(gender.rawValue.capitalized)
                        .tag(Optional(gender))
                }
            }
        }
    }
}

struct CharactersFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersFiltersView(filters: .constant(.init(
            name: "",
            status: .alive,
            species: "",
            type: "",
            gender: .female
        )))
    }
}
