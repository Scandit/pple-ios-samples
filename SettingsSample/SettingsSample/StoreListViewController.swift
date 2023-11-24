/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import ScanditShelf

final class StoreListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let authentication = Authentication.shared

    private let refreshControl = UIRefreshControl()

    private var stores: [Store] = []

    private var filteredStores: [Store] = []

    private let catalog = Catalog.shared

    private var selectedStore: Store?

    private var productCatalog: ProductCatalog?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearch()
        fetchStores()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadStores), for: .valueChanged)
    }

    @IBAction func unwindToStores(segue: UIStoryboardSegue) {
        searchBar.text = nil
        filteredStores = stores
        tableView.reloadData()
    }

    @IBAction private func onLogOut(_ sender: Any) {
        activityIndicator.startAnimating()

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await authentication.logout()
            } catch {
                showToast(message: error.localizedDescription)
            }
            
            activityIndicator.stopAnimating()
            perform(segue: .unwindToLogin)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? CaptureViewController,
              let store = selectedStore,
              let productCatalog = productCatalog else { return }

        controller.storeName = store.name
        controller.currency = store.currency
        controller.productCatalog = productCatalog
    }

    private func setUpSearch() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }

    private func fetchStores() {
        activityIndicator.startAnimating()

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let stores = try await self.catalog.getStores()
                self.update(stores: stores)
            } catch {
                self.showToast(message: error.localizedDescription)
            }

            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }

    private func showCaptureView(store: Store) {
        // First create the ProductCatalog object.
        //
        // If you are using the ShelfView backend as your product catalog provider, you only need to specify the Store,
        // for which you will perform the Price Check - just like in the code below.
        //
        // If on the other hand, you would like to use a different source of data for the ProductCatalog,
        // you should pass your custom implementation of the ProductProvider protocol, as the second argument.
        // For the Catalog.getProductCatalog method - check the docs for more details.
        productCatalog = Catalog.shared.getProductCatalog(storeID: store.id)

        if let selectedStore = selectedStore, selectedStore.id == store.id {
            // All required data are fetched and configured.
            view.isUserInteractionEnabled = true
            perform(segue: .showCaptureView, sender: nil)
            return
        }

        activityIndicator.startAnimating()
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await productCatalog?.update()
                self.selectedStore = store
                self.perform(segue: .showCaptureView, sender: nil)
            } catch {
                self.showToast(message: error.localizedDescription)
            }

            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }

    @objc private func reloadStores() {
        update(stores: [])
        fetchStores()
    }

    private func update(stores: [Store]) {
        self.stores = stores
        filteredStores = stores
        searchBar.text = nil
        tableView.reloadData()
    }
}

extension StoreListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredStores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let store = filteredStores[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = store.name
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.isUserInteractionEnabled = false
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()

        let store = filteredStores[indexPath.row]
        showCaptureView(store: store)
    }
}

extension StoreListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let stores = searchText.isEmpty
                     ? stores
                     : stores.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        reloadTable(stores: stores)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadTable(stores: stores)

        view.endEditing(true)
    }

    private func reloadTable(stores: [Store]) {
        filteredStores = stores
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension StoreListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
