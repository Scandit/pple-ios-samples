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

enum RectangularSizeSpecification: CaseIterable, CustomStringConvertible {
    case widthAndHeight, widthAndHeightAspect, heightAndWidthAspect, shorterDimensionAndAspectRatio

    var description: String {
        switch self {
        case .widthAndHeight: "Width and Height"
        case .widthAndHeightAspect: "Width and Height Aspect"
        case .heightAndWidthAspect: "Height and Width Aspect"
        case .shorterDimensionAndAspectRatio: "Shorter Dimension and Aspect Ratio"
        }
    }
}
