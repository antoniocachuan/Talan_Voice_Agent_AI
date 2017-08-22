//

import UIKit

enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}

// MARK: - UI Styling

extension ViewController {

    func applyStyle() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1810250878, green: 0.6670157909, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }

    
    
    func setUI(status: SpeechStatus) {
        switch status {
        case .ready:
            microphoneButton.setImage(#imageLiteral(resourceName: "available"), for: .normal)
            //microphoneButton.setImage(#imageLiteral(resourceName: "microphonenew"), for: .normal)
        case .recognizing:
           // microphoneButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)  old
            microphoneButton.setImage(#imageLiteral(resourceName: "unavailable"), for: .normal)
        case .unavailable:
            microphoneButton.setImage(#imageLiteral(resourceName: "unavailable"), for: .normal)
        }
    }

    /*func searchFlight(number: String) {
        if let flight = FlightsDataSource.searchFlight(number: number) {
            flightTextView.text = "\(number)\n\(flight.status)"
        }
    }*/
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FlightsDataSource.flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        let flight = FlightsDataSource.flights[indexPath.row]
        cell.textLabel?.text = flight.number
        cell.detailTextLabel?.text = flight.status
        return cell
    }
}
