import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
final class AssetDetailsViewModel {
    
    let asset: Asset
    var errorMessage: String?
    
    var showError = false
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    func addToFavourites() {
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not authenticated"
            showError = true
            return
        }
        
        let userId = user.uid
        
        let db = Firestore.firestore()
        db.collection("favourites")
            .document(userId)
            .setData(
                ["favourites": FieldValue.arrayUnion([asset.id])],
                merge: true
            )
        
    }
    
}
