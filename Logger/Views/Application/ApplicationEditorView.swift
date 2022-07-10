//

import SwiftUI

struct ApplicationEditorView: View {
    @StateObject private var viewModel = ApplicationEditorViewModel()
    let application: JobApplicationModel

    var body: some View {
        VStack {
            TextField("Company name", text: $viewModel.companyName)

            Button("Save") {
                viewModel.save()
            }

            Button("Delete") {
                viewModel.delete()
            }
        }
        .onAppear {
            viewModel.application = application
            viewModel.populateInfo()
        }
    }
}

struct ApplicationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationEditorView(application: .empty)
    }
}
