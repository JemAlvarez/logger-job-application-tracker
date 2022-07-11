//

import SwiftUI
import JsHelper

@main
struct LoggerApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @AppStorage(UserDefaults.Keys.appTimesOpenedNum.rawValue) var appTimesOpenedNum = 0

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                .environmentObject(coreDataManager)
                .onAppear {
                    let _ = TransactionObserver()

                    appTimesOpenedNum += 1

                    switch appTimesOpenedNum {
                    case 5, 20, 50, 100, 150:
                        UIApplication.requestStoreReview()
                    default:
                        break
                    }
                }
        }
    }
}
