import Foundation
import Dependencies

@Observable
final class AssetDetailsViewModel {
    
    let asset: Asset
    var errorMessage: String?
    var showError = false
    
    @ObservationIgnored
    @Dependency(\.assetsApiClient) var apiClient

    @ObservationIgnored
    @Dependency(\.authClient) var authClient
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    func addToFavourites() async {
        do {
            let user = try authClient.getCurrentUser()
            try await apiClient.saveFavourite(user, asset)
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            showError = true
        } catch {
            // TODO: Handle error
        }
    }
}
