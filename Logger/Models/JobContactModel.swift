//

import Foundation
import CoreData

struct JobContactModel {
    let id = UUID()
    let CD_ID: NSManagedObjectID?
    let email: String
    let name: String
    let number: Int
    let role: Role

    static let empty = JobContactModel(
        CD_ID: nil,
        email: "",
        name: "",
        number: 0000000000,
        role: .none
    )

    enum Role: String {
        case interviewer, developer, recruiter, none
        case hiringManager = "Hiring Manager"

        static func getRole(from string: String) -> Role {
            switch string {
            case "interviewer":
                return interviewer
            case "developer":
                return developer
            case "recruiter":
                return recruiter
            case "hiringManager":
                return hiringManager
            default:
                return none
            }
        }
    }
}
