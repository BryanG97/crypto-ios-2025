import SwiftUI
struct AssetDetailView: View {
    
    let asset: Asset
    
    var body: some View {
        Text(asset.name)
            .navigationTitle(asset.name)
    }
}

#Preview{
    NavigationStack{
        AssetDetailView(
            asset: .init(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "BTC",
                priceUsd: "80123.12",
                changePercent24Hr: "20.121212"
            )
        )
    }
}
