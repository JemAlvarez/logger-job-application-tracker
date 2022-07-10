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
        // TODO: filter, sort, query
        var output: [JobApplicationModel] = []

        for application in applications {
            output.append(coreDataManager.parseJobApplication(with: application))
        }

        return output
    }

    // delete
    func delete(_ application: JobApplicationModel) {
        if let id = application.CD_ID {
            withAnimation {
                coreDataManager.deleteAndSave(with: id)
            }
        }
    }
}
