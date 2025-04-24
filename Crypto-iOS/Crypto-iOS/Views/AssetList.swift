import SwiftUI

struct Assetlist: View{
    
    var viewModel: AssetListViewModel = .init()
    
    //@State var viewModel: AssetListViewModel = .init()
    
    var body: some View{
        NavigationStack{
            
            Text(viewModel.errorMessage ?? "")
            
            List {
                ForEach(viewModel.assets) { asset in
                    NavigationLink {
                        AssetDetailView(viewModel: .init(asset: asset))
                    } label: {
                        AssetView(assetViewState: .init(asset))
                    }
                }
            }
            .listStyle(.plain)
            .task{
                await viewModel.fetchAssets()
            }
            .navigationTitle("Home")
        }
        
    }
}

#Preview {
    Assetlist()
}

