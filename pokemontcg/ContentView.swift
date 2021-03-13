import SwiftUI

struct pokemonTCG : Codable {
    
    struct Cards:  Identifiable, Codable {
        let id : String
        let name: String
        let images: Images
    }
    
    struct Images:  Codable {
        let small: String
    }
    
    let data: [Cards]
}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data: data) else {
                return Image(systemName: "square.fill")
            }
            return Image(uiImage: image)
                .resizable()
        }
        return self
            .resizable()
    }
}

class PokemonViewModel: ObservableObject {
        @Published var pokemonCards: [pokemonTCG.Cards] = []
    
    func fetchCards(name: String){
        guard let url = URL(string: "https://api.pokemontcg.io/v2/cards?q=name:\(name)") else {
            print("Your API end point is invalid")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response = try? JSONDecoder().decode(pokemonTCG.self, from: data) {
                    DispatchQueue.main.async {
                        self.pokemonCards = response.data
                    }
                    return
                }
            }
            
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var pokeCardsVM = PokemonViewModel()
    @State var search: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.pokeCardsVM.pokemonCards.prefix(20)){ card in
                    VStack{
                        HStack{
                            Text(String(card.name))
                        }
                        if let cardURL = URL(string: card.images.small) {
                            Image(systemName: "square.fill").data(url: cardURL)
                                .frame(width: 325.0, height: 375.0)
                        }
                    }
                }
                if self.pokeCardsVM.pokemonCards.count == 0
                {
                        Text(String("No results found"))
                }
            }.navigationBarTitle("Pokemon TCG")
            .navigationBarItems(
                leading:
                TextField("Search for a card", text: $search)
                .padding(7)
                .background(Color(.systemGray2))
                .cornerRadius(8),
                
                trailing:Button(
                    action:{
                        print("Fetching json data")
                        self.pokeCardsVM.fetchCards(name: search)
                    },
                    label:{
                        Text("Search")
                    }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
