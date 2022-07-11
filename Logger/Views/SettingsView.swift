//

import SwiftUI
import JsHelper
import StoreKit

struct SettingsView: View {
    @AppStorage(UserDefaults.Keys.isSupporter.rawValue) var isSupporter = false
    let iapID = "com.jemalvarez.Logger.Support"
    @State var product: Product? = nil

    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss

    @State var copied = false

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 99)
                .fill(.gray)
                .opacity(.opacityLow)
                .frame(width: 80, height: 3)

            HStack {
                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)

            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Form {
                contact()

                donate()
            }

            VStack {
                Text("Made with ❤️ by Jem")
                Text("Version: \(Bundle.main.appBuild)")
            }
            .font(.footnote)
            .opacity(.opacityMedium)
        }
        .padding(.top)
        .task {
            await fetchProduct()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: - iap
extension SettingsView {
    func fetchProduct() async {
        do {
            let products = try await Product.products(for: [iapID])

            if let fetchedProduct = products.first {
                product = fetchedProduct
            }
        } catch {
            print("Unable to fetch product")
        }
    }

    func purchase() async {
        if let product = product {
            do {
                let purchaseResult = try await product.purchase()

                switch purchaseResult {
                case .success(let verificationResult):
                    switch verificationResult {
                    case .verified:
                        withAnimation {
                            isSupporter = true
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            } catch {
                print("Error pruchasing")
            }
        }
    }

    func restore() async {
        if let product = product {
            let entitlement = await product.currentEntitlement

            switch entitlement {
            case .verified:
                withAnimation {
                    isSupporter = true
                }
            default:
                break
            }
        }
    }
}

// MARK: - views
extension SettingsView {
    func donate() -> some View {
        Section(content: {
            if !isSupporter {
                HStack {
                    makeRow(
                        leftImage: "heart.fill",
                        color: .red,
                        text: "Donate and support",
                        rightImage: nil
                    ) {
                        Task {
                            await purchase()
                        }
                    }

                    Spacer()

                    Text("$0.99")
                        .foregroundColor(.blue)
                }

                Button("Restore") {
                    Task {
                        await restore()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("Thanks for your support! :)")
                }
            }
        }) {
            Text("Support")
        } footer: {
            Text(isSupporter ? "You're awesome :)" : "If you choose to donate you'll be supporting me and only me :)")
        }
    }

    func contact() -> some View {
        Section("Contact") {
            makeRow(
                leftImage: "person.crop.square.filled.and.at.rectangle.fill",
                color: .cyan,
                text: "Follow me on twitter",
                rightImage: "arrow.up.right"
            ) {
                openLink(MyContactInfo.twitter.rawValue, with: openURL)
            }

            makeRow(
                leftImage: "envelope.fill",
                color: .green,
                text: "Send me an email",
                rightImage: copied ? "checkmark" : "doc.on.clipboard.fill"
            ) {
                UIPasteboard.general.string = MyContactInfo.email.rawValue

                withAnimation {
                    copied = true
                }
            }

            makeRow(
                leftImage: "star.fill",
                color: .yellow,
                text: "Review on the App Store",
                rightImage: "arrow.up.right"
            ) {
                openLink(String.rateOnAppStoreLink(with: MyContactInfo.appId.rawValue), with: openURL)
            }
        }
    }

    func makeRow(leftImage: String, color: Color, text: String, rightImage: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Group {
                    Image(systemName: leftImage)
                        .foregroundColor(color)
                    Text(text)
                }
                .foregroundColor(.primary)

                Spacer()

                if let rightImage = rightImage {
                    Image(systemName: rightImage)
                }
            }
        }
    }
}
