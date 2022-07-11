//

import SwiftUI
import CoreData

struct JobApplicationModel: Identifiable {
    let id = UUID()
    let CD_ID: NSManagedObjectID?
    let companyName: String
    let dateApplied: Date
    let dateModified: Date
    let interviewDate: Date?
    let jobLink: String
    let jobTitle: String
    let location: String
    let notes: String
    let recruitingCompany: String
    let salary: Int
    let status: Status
    let contacts: [JobContactModel]

    static let empty = JobApplicationModel(
        CD_ID: nil,
        companyName: "",
        dateApplied: .now,
        dateModified: .now,
        interviewDate: nil,
        jobLink: "",
        jobTitle: "",
        location: "",
        notes: "",
        recruitingCompany: "",
        salary: 0,
        status: .applied,
        contacts: []
    )

    enum Status: String, CaseIterable, Comparable {
        static func < (lhs: JobApplicationModel.Status, rhs: JobApplicationModel.Status) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

        case applied, rejected, offer, waiting, call, interview, none

        var color: Color {
            switch self {
            case .applied:
                return .cyan
            case .rejected:
                return .red
            case .offer:
                return .green
            case .waiting:
                return .yellow
            case .call:
                return .orange
            case .interview:
                return .purple
            case .none:
                return .gray
            }
        }

        static func getStatus(from string: String) -> Status {
            switch string {
            case "applied":
                return applied
            case "rejected":
                return rejected
            case "offer":
                return offer
            case "waiting":
                return waiting
            case "call":
                return call
            case "interview":
                return interview
            default:
                return none
            }
        }
    }
}
