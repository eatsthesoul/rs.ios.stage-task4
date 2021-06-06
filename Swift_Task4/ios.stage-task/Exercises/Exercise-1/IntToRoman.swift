import Foundation

public extension Int {
    
    var roman: String? {
        
        let romanArray = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicArray = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var number = self
        var resultString = ""
        
        for (index, romanChar) in romanArray.enumerated() {
            
            let currentArabicValue = arabicArray[index]
            
            let valuesInNumberCounter = number / currentArabicValue
            
            if valuesInNumberCounter > 0 {
                
                for _ in 0..<valuesInNumberCounter {
                    resultString += romanChar
                }
                
                number -= currentArabicValue * valuesInNumberCounter
            }
        }

        return (resultString != "") ? resultString : nil
    }
}
