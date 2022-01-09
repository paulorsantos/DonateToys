import Foundation

struct Toy {
    let name: String
    let state: Int
    let donorName: String
    let address: String
    let phoneNumber: String
    let id: String
    
    var stateName: String {
        switch state {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        case 2:
            return "Precisa de reparo"
        default:
            return ""
        }
    }}
