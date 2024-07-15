import Foundation

extension URLSession {
    
    func dataTask<T: Decodable>(with request: URLRequest, type: T.Type, completionHandler: @escaping (_ model: T?, _ error: Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let data = data else {
                    completionHandler(nil, nil)
                    return
                }
                let model = try JSONDecoder().decode(T.self, from: data)
                completionHandler(model, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    func dataTask<T: Decodable>(with url: URL, type: T.Type, completionHandler: @escaping (_ model: T?, _ error: Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { data, response, error in
            do {
                if let error = error { throw error }
                guard let data = data else {
                    completionHandler(nil, nil)
                    return
                }
                let model = try JSONDecoder().decode(T.self, from: data)
                completionHandler(model, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
}

// MARK: Progress support

extension URLSession {
    
    func startDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Progress {
        var progress: Progress?
        let task = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
        if #available(macOSApplicationExtension 10.13,
            iOSApplicationExtension 11.0,
            tvOSApplicationExtension 11.0,
            watchOSApplicationExtension 4.0, *) {
            return task.progress
        } else {
            progress = Progress(parent: Progress.current())
            progress!.totalUnitCount = 100
            progress!.cancellationHandler = task.cancel
            progress!.isPausable = true
            progress!.pausingHandler = task.suspend
            progress!.resumingHandler = task.resume
            return progress!
        }
    }
    
    func startDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Progress {
        var progress: Progress?
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        if #available(macOSApplicationExtension 10.13,
            iOSApplicationExtension 11.0,
            tvOSApplicationExtension 11.0,
            watchOSApplicationExtension 4.0, *) {
            return task.progress
        } else {
            progress = Progress(parent: Progress.current())
            progress!.totalUnitCount = 100
            progress!.cancellationHandler = task.cancel
            progress!.isPausable = true
            progress!.pausingHandler = task.suspend
            progress!.resumingHandler = task.resume
            return progress!
        }
    }
    
    func startDataTask<T: Decodable>(with request: URLRequest, type: T.Type, completionHandler: @escaping (_ model: T?, _ error: Error?) -> Void) -> Progress {
        var progress: Progress?
        let task = dataTask(with: request) { data, response, error in
            progress?.completedUnitCount = 100
            do {
                if let error = error { throw error }
                guard let data = data else {
                    completionHandler(nil, nil)
                    return
                }
                let model = try JSONDecoder().decode(T.self, from: data)
                completionHandler(model, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        defer { task.resume() }
        if #available(macOSApplicationExtension 10.13,
            iOSApplicationExtension 11.0,
            tvOSApplicationExtension 11.0,
            watchOSApplicationExtension 4.0, *) {
            return task.progress
        } else {
            progress = Progress(parent: Progress.current())
            progress!.totalUnitCount = 100
            progress!.cancellationHandler = task.cancel
            progress!.isPausable = true
            progress!.pausingHandler = task.suspend
            progress!.resumingHandler = task.resume
            return progress!
        }
    }
    
    func startDataTask<T: Decodable>(with url: URL, type: T.Type, completionHandler: @escaping (_ model: T?, _ error: Error?) -> Void) -> Progress {
        var progress: Progress?
        let task = dataTask(with: url) { data, response, error in
            progress?.completedUnitCount = 100
            do {
                if let error = error { throw error }
                guard let data = data else {
                    completionHandler(nil, nil)
                    return
                }
                let model = try JSONDecoder().decode(T.self, from: data)
                completionHandler(model, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        defer { task.resume() }
        if #available(macOSApplicationExtension 10.13,
            iOSApplicationExtension 11.0,
            tvOSApplicationExtension 11.0,
            watchOSApplicationExtension 4.0, *) {
            return task.progress
        } else {
            progress = Progress(parent: Progress.current())
            progress!.totalUnitCount = 100
            progress!.cancellationHandler = task.cancel
            progress!.isPausable = true
            progress!.pausingHandler = task.suspend
            progress!.resumingHandler = task.resume
            return progress!
        }
    }
}
