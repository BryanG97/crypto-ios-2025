import Foundation

@Observable
final class AssetListViewModel{
    
    var errorMessage: String?
    var assets: [Asset] = []
    
    func fetchAssets() async{
        let urlSession = URLSession.shared
        
        guard let url = URL(string: "https://rest.coincap.io/v3/assets?apiKey=b658780c36366042da97d87e23bd6bf41ad905cf4305dad1f9ce68c27501ea4d") else {
            return
        }
        
        do{
            let (data, _) = try await urlSession.data(for: URLRequest(url: url))
            let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
            self.assets = assetsResponse.data
            print(assets)
        }catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
}
