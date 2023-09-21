import SwiftUI

public struct PaginatedList<ListElement: Identifiable, Content: View>: View {
    @Binding var canFetchNextPage: Bool
    @Binding var isLoading: Bool

    var listElements: [ListElement]
    var nextPageAction: () async -> Void
    var content: (ListElement) -> Content

    public init(
        canFetchNextPage: Binding<Bool>,
        isLoading: Binding<Bool>,
        elements: [ListElement],
        @ViewBuilder content: @escaping (ListElement) -> Content,
        nextPageAction: @escaping () async -> Void
    ) {
        self._canFetchNextPage = canFetchNextPage
        self._isLoading = isLoading
        self.listElements = elements
        self.content = content
        self.nextPageAction = nextPageAction
    }

    public var body: some View {
        verticalList
    }

    private var verticalList: some View {
        ScrollView {
            LazyVStack {
                listContent
            }
        }
    }

    @ViewBuilder private var listContent: some View {
        if listElements.isEmpty {
            HStack {
                Spacer()
                Text("No data")
                    .font(.largeTitle)
                    .padding()
                    .background(.bar)
                    .cornerRadius(16)
                Spacer()
            }
        } else {
            ForEach(listElements) {
                content($0)
            }
            if canFetchNextPage, !isLoading {
                moreDataButton
            } else if isLoading {
                ProgressView()
            }
        }
    }

    private var moreDataButton: some View {
        Button(
            action: {  Task { await nextPageAction() }},
            label: {
                Label("More", image: .download)
                    .font(.largeTitle)
                    .padding()
            }
        )
        .background(.bar)
        .cornerRadius(16)
    }
}

struct PaginatedList_Previews: PreviewProvider {
    static var previews: some View {
        struct Person: Identifiable {
            let id: UUID = .init()
            var index: Int
        }

        return PaginatedList(
            canFetchNextPage: .constant(true),
            isLoading: .constant(true),
            elements: (1...10).map { Person(index: $0) },
            content: { Text("Row \($0.index)") },
            nextPageAction: { print("next Page")}
        )
    }
}
