import SwiftUI
import DesignKit

struct EpisodeView: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.name)
                .font(.title)
            Text("Air Date: ")
                .bold()
            +
            Text(episode.air_date)
            Text("Episode: ")
                .bold()
            +
            Text(episode.episode)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.surface))
        .cornerRadius(16)
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        let episode = Episode(
            id: 28,
            name: "The Ricklantis Mixup",
            air_date: "September 10, 2017",
            episode: "S03E07",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/2",
            ],
            url: "https://rickandmortyapi.com/api/episode/28",
            created: "2017-11-10T12:56:36.618Z"
        )

        return EpisodeView(episode: episode)
    }
}
