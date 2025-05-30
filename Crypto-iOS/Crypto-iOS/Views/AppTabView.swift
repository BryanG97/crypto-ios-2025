import SwiftUI

struct AppTabView: View{
    var body: some View{
        TabView{
            Tab("Home", systemImage: "house"){
                Assetlist()
                    .navigationTitle("Home")
            }
            Tab("Favourites", systemImage: "star"){
                Text("Favourites")
            }
            Tab("Settings", systemImage: "gear"){
                SettingsView()
            }
        }
        
    }
}

#Preview{
    AppTabView()
}
