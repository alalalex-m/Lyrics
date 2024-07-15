extension Optional {
    
    func filter(_ condition: (Wrapped) -> Bool) -> Wrapped? {
        if let v = self, condition(v) {
            return v
        }
        return nil
    }
}
