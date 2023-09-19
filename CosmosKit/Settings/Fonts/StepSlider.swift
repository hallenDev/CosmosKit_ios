import Foundation

class StepSlider: UISlider {
    private var values: [Int] = []
    private var lastIndex: Int?
    var callback: ((Int) -> Void)?

    func configure(values: [Int], callback: @escaping (_ newValue: Int) -> Void) {
        self.values = values
        self.callback = callback
        self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)
        let steps = values.count - 1
        self.minimumValue = 0
        self.maximumValue = Float(steps)
    }

    @objc func handleValueChange(sender: UISlider) {
        let newIndex = Int(sender.value + 0.5)
        self.setValue(Float(newIndex), animated: false)
        let didChange = lastIndex == nil || newIndex != lastIndex!
        if didChange {
            lastIndex = newIndex
            let actualValue = self.values[newIndex]
            self.callback?(actualValue)
        }
    }
}
