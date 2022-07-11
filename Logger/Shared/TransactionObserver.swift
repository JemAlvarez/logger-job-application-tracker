//

import SwiftUI
import StoreKit

class TransactionObserver {
    @AppStorage(UserDefaults.Keys.isSupporter.rawValue) var isSupporter = false
    let iapID = "com.jemalvarez.Logger.Support"

    var updates: Task<Void, Never>? = nil

    init() {
        Task.init {
            await checkEntitlement()
        }
        updates = Task {
            await listenForTransactions()
        }
    }

    deinit {
        // Cancel the update handling task when you de-initialize the class.
        updates?.cancel()
    }

    private func checkEntitlement() async {
        do {
            let products = try await Product.products(for: [iapID])

            if let product = products.first {
                let entitlement = await product.currentEntitlement

                switch entitlement {
                case .verified:
                    DispatchQueue.main.async { [weak self] in
                        withAnimation {
                            self?.isSupporter = true
                        }
                    }
                default:
                    DispatchQueue.main.async { [weak self] in
                        withAnimation {
                            self?.isSupporter = false
                        }
                    }
                }
            }
        } catch {
            error.printError(for: "Fetching IAP")
        }
    }

    private func listenForTransactions() async {
        for await verificationResult in Transaction.updates {
            guard case .verified(let transaction) = verificationResult else { continue }

            if let _ = transaction.revocationDate {
                DispatchQueue.main.async { [weak self] in
                    withAnimation {
                        self?.isSupporter = false
                    }
                }
            } else if let expirationDate = transaction.expirationDate, expirationDate < .now {
                continue
            } else if transaction.isUpgraded {
                continue
            } else {
                DispatchQueue.main.async { [weak self] in
                    withAnimation {
                        self?.isSupporter = true
                    }
                }
            }
        }
    }
}
