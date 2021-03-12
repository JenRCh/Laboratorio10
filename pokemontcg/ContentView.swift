import SwiftUI

struct ContentView: View {
    
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Text("Pokemon TCG Guru")
                    .font(.title)
                    .foregroundColor(Color(.systemGray2))
                    .padding(5)
                Text("The Ultimate Pokemon Card Database")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(5)
            HStack {
                
                TextField("Search for a card", text:$text)
                    .padding(7)
                    .padding(.horizontal,25)
                    .background(Color(.systemGray))
                    .cornerRadius(8)
                    .padding(.horizontal,10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing{
                    Button(action:{
                        self.isEditing = false
                        self.text = ""
                    }) {
                        Text("Cancel")
                    }.padding(.trailing,10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                            }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant(""))
    }
}
