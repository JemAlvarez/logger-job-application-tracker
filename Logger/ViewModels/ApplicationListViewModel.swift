//

import SwiftUI

class ApplicationListViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared

    @Published var searchQuery = ""
    @Published var isSheetOpenForSettings = false
    @Published var isSheetOpenForApplicationEdit = false
    @Published var filtering: JobApplicationModel.Status = .none
    @Published var sorting: SortCategories = .modifiedDate
    @Published var descending = true

    // filtered/sorted/queried
    func getApplications(_ applications: FetchedResults<JobApplication>) -> [JobApplicationModel] {
        var output: [JobApplicationModel] = []

        for application in applications {
            output.append(coreDataManager.parseJobApplication(with: application))
        }

        output = query(output)
        print("================", output)
        output = filter(output)
        output = sort(output)

        return output
    }

    func query(_ applications: [JobApplicationModel]) -> [JobApplicationModel] {
        if searchQuery.isEmpty {
            return applications
        }

        return applications.filter { $0.companyName.contains(searchQuery) }
    }

    func filter(_ applications: [JobApplicationModel]) -> [JobApplicationModel] {
        if filtering != .none {
            return applications.filter { $0.status == filtering }
        }
        return applications
    }

    func sort(_ applications: [JobApplicationModel]) -> [JobApplicationModel] {
        switch sorting {
        case .companyName:
            return applications.sorted { descending ? $0.companyName > $1.companyName : $0.companyName < $1.companyName }
        case .appliedDate:
            return applications.sorted { descending ? $0.dateApplied > $1.dateApplied : $0.dateApplied < $1.dateApplied }
        case .status:
            return applications.sorted { descending ? $0.status > $1.status : $0.status < $1.status }
        default:
            return applications.sorted { descending ? $0.dateModified > $1.dateModified : $0.dateModified < $1.dateModified }
        }
    }

    // delete
    func delete(_ application: JobApplicationModel) {
        if let id = application.CD_ID {
            withAnimation {
                coreDataManager.delete(with: id)
                coreDataManager.save()
            }
        }
    }
}
