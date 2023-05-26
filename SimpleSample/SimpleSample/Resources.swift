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

extension String {
    static let empty = ""
    static let appName = "Swift PPLE Simple Sample"
    static let initial = "Preparing to launch Price Check"
    static let cameraPermissionDenied = "Price Check requires access to the camera"
    static let authenticationFailed = "Failed to authenticate username: \(Credentials.username)"
    static let storeDownloadFailed = "Failed to fetch the Stores"
    static let storesEmpty = "Organization has no stores"
    static func catalogDownloadFailed(storeName: String) -> String {
        "Failed to fetch the config for the \(storeName) store"
    }
}
