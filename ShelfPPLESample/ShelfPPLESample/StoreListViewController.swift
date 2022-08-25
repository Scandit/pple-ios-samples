import UIKit
import ScanditShelf

final class StoreListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var stores: [Store] = []
    private var filteredStores: [Store] = []

    private let catalog = Catalog.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearch()
        fetchStores()
    }

    @IBAction func unwindToStores(segue: UIStoryboardSegue) {
        searchBar.text = nil
        filteredStores = stores
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? CaptureViewController,
              let store = sender as? Store else { return }

        controller.store = store
    }

    private func setUpSearch() {
        searchBar.delegate = self
    }

    private func fetchStores() {
        activityIndicator.startAnimating()

        catalog.getStores { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()

            switch result {
            case .success(let stores):
                self.stores = stores
                self.filteredStores = stores
                self.tableView.reloadData()
            case .failure(let error):
                self.showError(description: error.localizedDescription)
            }
        }
    }

    private func showError(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
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
        let store = filteredStores[indexPath.row]
        perform(segue: .showCaptureView, sender: store)
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
    }

    private func reloadTable(stores: [Store]) {
        filteredStores = stores
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
