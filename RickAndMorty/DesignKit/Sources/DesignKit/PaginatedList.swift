import SwiftUI

public struct PaginatedList<ListElement: Identifiable, Header: View, Content: View>: View {
    @Binding var canFetchNextPage: Bool
    var listElements: [ListElement]
    var nextPageAction: () async -> Void
    var header: () -> Header
    var content: (ListElement) -> Content

    public init(
        canFetchNextPage: Binding<Bool>,
        elements: [ListElement],
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping (ListElement) -> Content,
        nextPageAction: @escaping () async -> Void
    ) {
        self._canFetchNextPage = canFetchNextPage
        self.listElements = elements
        self.header = header
        self.content = content
        self.nextPageAction = nextPageAction
    }

    public var body: some View {
        List {
            Section(
                content: {
                    if listElements.isEmpty {
                        HStack {
                            Spacer()
                            Text("Empty list. Try refreshing !")
                            Spacer()
                        }
                    } else {
                        ForEach(listElements) {
                            content($0)
                        }
                    }
                    if canFetchNextPage, !listElements.isEmpty {
                        HStack {
                            Spacer()
                            ProgressView()
                                .task { await nextPageAction() }
                            Spacer()
                        }
                    }
                },
                header: { header() }
            )
        }
//        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
}

public extension PaginatedList where Header == EmptyView {
    init(
        canFetchNextPage: Binding<Bool>,
        elements: [ListElement],
        @ViewBuilder content: @escaping (ListElement) -> Content,
        nextPageAction: @escaping () async -> Void
    ) {
        self._canFetchNextPage = canFetchNextPage
        self.listElements = elements
        self.header = { EmptyView() }
        self.content = content
        self.nextPageAction = nextPageAction
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
            elements: (1...10).map { Person(index: $0) },
            content: { Text("Row \($0.index)") },
            nextPageAction: { print("next Page")}
        )
    }
}
