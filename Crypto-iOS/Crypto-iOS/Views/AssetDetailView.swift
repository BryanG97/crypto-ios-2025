import SwiftUI

struct AssetDetailView: View {
    
    @State var viewModel: AssetDetailsViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.asset.name)
            Button {
                Task {
                    await viewModel.addToFavourites()
                }
                
            } label: {
                Text("Add to favourites")
            }
        }
        .navigationTitle(viewModel.asset.name)
        .alert(
            viewModel.errorMessage ?? "",
            isPresented: $viewModel.showError) {
                Button("OK") {
                }
            }
    }
}

#Preview {
    NavigationStack {
        AssetDetailView(
            viewModel: .init(
                asset: .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "123123.123123",
                    changePercent24Hr: "9.99292"
                )
            )
        )
    }
    
}
