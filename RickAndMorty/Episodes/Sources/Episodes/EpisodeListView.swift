import SwiftUI

@MainActor
class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    let episodesRepository: EpisodesRepositoryProtocol

    init(episodesRepository: EpisodesRepositoryProtocol = EpisodesRepository()) {
        self.episodesRepository = episodesRepository
    }

    func getEpisodes() async {
        do {
            self.episodes = try await episodesRepository.getEpisodeList()
        } catch {
            print(error)
        }
    }
}

public struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    public init() {}
    
    public var body: some View {
        List(viewModel.episodes) {
            EpisodeView(episode: $0)
        }
        .listStyle(.plain)
        .task { await viewModel.getEpisodes() }
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
    }
}
