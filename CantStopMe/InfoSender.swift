import Foundation
import UIKit

func sendDeviceInfoToServer() {
    let device = UIDevice.current
    let infos: [String: String] = [
        "device": device.name,
        "model": device.model,
        "ios": device.systemVersion,
        "uuid": device.identifierForVendor?.uuidString ?? "unknown"
    ]
    guard let url = URL(string: "http://<ADRESSE_IP_SERVEUR>:5000/info") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: infos, options: [])
    URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
} 