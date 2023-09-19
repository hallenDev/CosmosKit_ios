import Foundation

protocol CosmosActivityEnabledViewController: UIViewController {
    var activityIndicator: CosmosActivityIndicator! { get set }
    var cosmos: Cosmos! { get set }
}

extension CosmosActivityEnabledViewController {

    /**
     This method creates, adds and constrains the `CosmosActivityIndicator` to the view
     - Important
     If the activity indicator should not be configured as usual or any additional logic be required,
     this method can be overridden with the desired functionality
     */
    func configureActivityIndicator(forceUIKit: Bool = false) {
        activityIndicator = CosmosActivityIndicator(cosmos: cosmos, frame: view.frame, forceUIKit: forceUIKit)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
