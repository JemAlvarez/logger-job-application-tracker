//

import SwiftUI

@main
struct LoggerApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                .environmentObject(coreDataManager)
        }
    }
}
