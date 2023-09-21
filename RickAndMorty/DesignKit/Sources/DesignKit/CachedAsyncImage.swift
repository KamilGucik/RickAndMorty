import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    enum State {
        case loading
        case failure
        case loaded(Data)
    }
    @Published var state: State = .loading

    func load(url: URL?) async {
        guard let url else {
            self.state = .failure
            return
        }
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

public struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
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
                Image(.errorImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
        .task { await imageLoader.load(url: url) }
    }
}
