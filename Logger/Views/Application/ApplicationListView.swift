//

import SwiftUI
import JsHelper

struct ApplicationListView: View {
    @StateObject private var viewModel = ApplicationListViewModel()
    @EnvironmentObject private var coreDataManager: CoreDataManager
    @FetchRequest(sortDescriptors: [])
    var applications: FetchedResults<JobApplication>

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if applications.count == 0 {
                    emptyList()
                } else {
                    list()
                }

                bottomBar()
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search company or contact...")
            .navigationTitle("Logger")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isSheetOpenForApplicationEdit) {
                ApplicationEditorView(application: .empty, isSheet: true)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $viewModel.isSheetOpenForSettings) { SettingsView() }
            // toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.isSheetOpenForSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(SortCategories.allCases, id: \.self.rawValue) { category in
                            Button(action: {
                                viewModel.sorting = category
                            }) {
                                if viewModel.sorting == category {
                                    Label(category.rawValue.capitalized, systemImage: "checkmark")
                                } else {
                                    Text(category.rawValue.capitalized)
                                }
                            }
                        }

                        Divider()

                        Button(action: {
                            viewModel.descending.toggle()
                        }) {
                            Label(viewModel.descending ? "Descending" : "Ascending", systemImage: "arrow.up.arrow.down")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(JobApplicationModel.Status.allCases, id: \.self.rawValue) { status in
                            Button(action: {
                                viewModel.filtering = status
                            }) {
                                if viewModel.filtering == status {
                                    Label(status.rawValue.capitalized, systemImage: "checkmark")
                                } else {
                                    Text(status.rawValue.capitalized)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
    }
}

struct ApplicationListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationListView()
    }
}

// MARK: - extensions
extension ApplicationListView {

    func emptyList() -> some View {
        Text("Add you first job application \(Image(systemName: "arrow.turn.right.down"))")
            .opacity(.opacityMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func list() -> some View {
        List(viewModel.getApplications(applications)) { application in
            ApplicationListRowView(application: application)
                .swipeActions(allowsFullSwipe: true) {
                    Button(action: {
                        viewModel.delete(application)
                    }) {
                        Image(systemName: "trash.fill")
                    }
                    .tint(.red)
                }
        }
    }

    func bottomBar() -> some View {
        ZStack {
            Text("\(applications.count) application\(applications.count == 1 ? "" : "s")")

            HStack {
                Spacer()

                Button(action: {
                    viewModel.isSheetOpenForApplicationEdit = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
        .padding([.horizontal, .top])
        .background(.ultraThinMaterial)
    }
}
