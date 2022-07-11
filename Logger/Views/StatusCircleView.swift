//

import SwiftUI

struct StatusCircleView: View {
    let color: Color

    var body: some View {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.leading, -10)
    }
}

struct StatusCircleView_Previews: PreviewProvider {
    static var previews: some View {
        StatusCircleView(color: .blue)
    }
}
