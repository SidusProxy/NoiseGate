
import Foundation
import SoundAnalysis
import CoreML
import AudioKit
class ResultsObserver: NSObject, SNResultsObserving {
    /// Notifies the observer when a request generates a prediction.
    ///
    var classification2:SNClassification? = nil
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else  { return }

        // Get the prediction with the highest confidence.
        guard let classification = result.classifications.first else { return }
        classification2=classification
        // Get the starting time.
        let timeInSeconds = result.timeRange.start.seconds

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
}
