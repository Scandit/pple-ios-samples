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

import ScanditShelf

extension RectangularViewfinderStyle: CaseIterable, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias AllCases = [RectangularViewfinderStyle]
    public static var allCases: AllCases {
        return [.square, .rounded]
    }

    public var description: String {
        switch self {
        case .square:
            return "Square"
        case .rounded:
            return "Rounded"
        @unknown default:
            preconditionFailure("Unhandled case - \(self)")
        }
    }

    public var debugDescription: String {
        return description.lowercased()
    }
}

extension RectangularViewfinderLineStyle: CaseIterable, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias AllCases = [RectangularViewfinderLineStyle]
    public static var allCases: AllCases {
        return [.bold, .light]
    }

    public var description: String {
        switch self {
        case .bold:
            return "Bold"
        case .light:
            return "Light"
        @unknown default:
            preconditionFailure("Unhandled case - \(self)")
        }
    }

    public var debugDescription: String {
        return description.lowercased()
    }
}
