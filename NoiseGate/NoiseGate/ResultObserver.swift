
import Foundation
import SoundAnalysis
import CoreML
import AudioKit
class ResultsObserver: NSObject, SNResultsObserving {
    /// Notifies the observer when a request generates a prediction.
    ///
    var classification2:String = ""
    var array:[String] = []
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else  { return }

        // Get the prediction with the highest confidence.
        guard let classification = result.classifications.first else { return }
        array.append(classification.identifier)
        // Get the starting time.
        let timeInSeconds = result.timeRange.start.seconds
        var counts: [String: Int] = [:]

        for item in array {
            counts[item] = (counts[item] ?? 0) + 1
        }

        print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"

        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
        }
        let greatestHue = counts.max { a, b in a.value < b.value }
        print(greatestHue?.key ?? "")
        classification2=greatestHue?.key ?? ""
        // Convert the time to a human-readable string.
        let formattedTime = String(format: "%.2f", timeInSeconds)
        print("Analysis result for audio at time: \(formattedTime)")

        // Convert the confidence to a percentage string.
        let percent = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", percent)
        
        // Print the classification's name (label) with its confidence.
        print("\(classification.identifier): \(percentString) confidence.\n")
      
    }


    /// Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    /// Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
    func mostFrequent<T: Hashable>(array: [T]) -> (value: T, count: Int)? {

        let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }

        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }

        // array was empty
        return nil
    }
}
