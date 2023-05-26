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

import Foundation
import ScanditShelf

/**
 * Dummy implementation of the ProductProvider protocol.
 *
 * Bear in mind that the findProduct(...) method of your custom ProductProvider should be fast,
 * as it might need to be called on every camera frame.
 * Therefore it is advised to cache the products in-memory or local database, rather than to
 * request them on the fly, every time the findProduct(...) method is called.
 */
final class ExternalProductProvider: ProductProvider {

    private let store: Store
    private lazy var products = [
        "7846987774588": Product(
            id: 0,
            code: "7846987774588",
            category: nil,
            name: "Fair Trade Espresso",
            storeId: store.id,
            price: 7.99,
            promotion: nil),
        "7654782245697": Product(
            id: 1,
            code: "7654782245697",
            category: nil,
            name: "Classic Espresso",
            storeId: store.id,
            price: 5.99,
            promotion: nil),
        "7853105120547": Product(
            id: 2,
            code: "7853105120547",
            category: nil,
            name: "Honey & Nut Muesli",
            storeId: store.id,
            price: 6.99,
            promotion: nil)
    ]

    init(store: Store) {
        self.store = store
    }

    func findProduct(code: String) -> Product? {
        products[code]
    }
}
