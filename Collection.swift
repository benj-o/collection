/**
 MIT License
 
 Copyright © 2019 Benji Burgess <benjiburgess.com> <benji@benjiburgess.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

*/


import SwiftUI

/**
 Collection: A SwiftUI Collection view
 
 Present content in an ordered grid.
 Provides only the most essential functionality.
 
 # Example:
 
     Collection(data, columns: colsCount) { element in
        // Views...
     }
 
 - Parameters:
    - data: An array of data which can be accessed inside the Collection content. Each element **must** conform to `Identifiable`.
    - columns: Number of columns to present.
 
 - Version: 1.0 (27th August 2019)
 - Bug: Due to a bug in `GeometryReader`, Collection can not handle the last row correctly if the number of items to display is less than the column count. The result is that the last columns's items will stretch to fill the container.
 
 - Precondition: Elements of the data array must conform to `Identifiable`.
 - Author: [Benji Burgess](benjiburgess.com)
 - Copyright: Copyright © Benji Burgess 2019.
 */
struct Collection<Element: Identifiable, Content>: View where Content: View {
    
    typealias Data = Array<Element>
    
    /// An array of `Identifiable` from which data can be extracted  from.
    let data: Data
    
    /// Column count, specified in integers.
    let columns: Int
    var content: (Element) -> Content
    
    /// Spacing between items, on the X-axis
    ///
    /// Custom spacing is not yet implemented.
    let horizontalSpacing: Length
    
    /// Spacing between items, on the Y-axis.
    ///
    /// Custom spacing is not yet implemented.
    let verticalSpacing: Length
    
    
    private var rowCount: Int {
        Int(data.count / columns)
    }
    
    var columnSize: (GeometryProxy) -> Length {
        
        { (reader: GeometryProxy) -> Length in
        
            (reader.size.width - (self.horizontalSpacing * Length(self.columns - 1))) / Length(self.columns)
            
        }
    }
    
    
    private func row(withColumns upperBound: Int, usingIterator iterator: inout Data) -> Data {
        
        /// Content of the row
        let rowContent: Data
        
        /// The number of Views which will be displayed per row.
        ///
        /// This will normally be just the number of columns, but for the last row it wilk be the number of values left in `iterator`
        var columnCountForCurrentRow = upperBound
        
        
        if columns - iterator.count >= 0 { // If there are $columns values or more inside $iterator
            
            rowContent = iterator // Row content (items to be displayed) = the remaining data
            columnCountForCurrentRow = iterator.count
            
        } else {
            rowContent = Array(iterator[0..<columnCountForCurrentRow]) // Row content is set to **all** the remaining elements inside the data list
        }
        
        iterator.removeSubrange(0..<columnCountForCurrentRow) // Remove data which has been displayed already
        
        return rowContent
        
    }
    
    
    var body: some View {
        
        var iterator: Data = data
        
//        return GeometryReader { geo in
        
        return VStack {
            
            ForEach(self.data) { _ in
                
                HStack {
                    
                    ForEach(self.row(withColumns: self.columns, usingIterator: &iterator)) { view in
                        
                        self.content(view)
//                        .padding(.trailing, self.horizontalSpacing)
                        
                        
                    }
                    
                }
//                .padding(.bottom, self.verticalSpacing)
                
            }
            
        }
        
//        }
        
    }
    
    
    init(
        _ data: Data,
        columns: Int = 2,
        verticalSpacing vSpacing: Length = SMALL_MARGIN,
        horizontalSpacing hSpacing: Length = SMALL_MARGIN,
        @ViewBuilder content: @escaping (Element) -> Content) {
        
        self.data = data
        self.columns = columns
        self.content = content
        self.verticalSpacing = vSpacing
        self.horizontalSpacing = hSpacing
        
    }
    
}
