import Foundation

fileprivate enum Side {
    case left
    case right
    case top
    case bottom
}

final class FillWithColor {
    
    private var mutableImage: [[Int]]!
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        if row < 0 || column < 0 || row >= image.count || column >= image[0].count || image[row][column] == newColor { return image }
        
        mutableImage = image
        let basicColor = image[row][column]
        
        fillPixels(image, row, column, basicColor: basicColor, newColor)
        
        return mutableImage
    }
    
    private func fillPixels(_ image: [[Int]], _ row: Int, _ column: Int, basicColor: Int, _ newColor: Int) {
        
        if (row < 0 || column < 0 || row >= image.count || column >= image[0].count || image[row][column] != basicColor) {
            return
        }
        
        mutableImage[row][column] = newColor
        
        fillPixels(mutableImage, row - 1, column, basicColor: basicColor, newColor)
        fillPixels(mutableImage, row + 1, column, basicColor: basicColor, newColor)
        fillPixels(mutableImage, row, column - 1, basicColor: basicColor, newColor)
        fillPixels(mutableImage, row, column + 1, basicColor: basicColor, newColor)
    }
}
