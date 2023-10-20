
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}

//extension URLSession {
//    func data(
//        for request: URLRequest,
//        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//            let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
//                DispatchQueue.main.async {
//                    completion(result)
//                }
//            }
//            let task = dataTask(with: request, completionHandler: { data, response, error in
//                if let data = data,
//                   let response = response,
//                   let statusCode = (response as? HTTPURLResponse)?.statusCode
//                {
//                    if 200 ..< 300 ~= statusCode {
//                        fulfillCompletion(.success(data))
//                    } else {
//                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                    }
//                } else if let error = error {
//                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
//                } else {
//                    fulfillCompletion(.failure(NetworkError.urlSessionError))
//                }
//            })
//            task.resume()
//            return task
//        }
//}

//extension URLSession {
//    func objectTask<T: Decodable>(
//        for request: URLRequest,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) -> URLSessionTask {
//
//        let task = dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                }
//                if let data = data,
//                   let response = response,
//                   let statusCode = (response as? HTTPURLResponse)?.statusCode
//                {
//                    if 200 ..< 300 ~= statusCode {
//                        do {
//                            let decoder = JSONDecoder()
//                            let result = try decoder.decode(T.self, from: data)
//                            completion(.success(result))
//                            print("try decoder.decode - success(result)")
//                        } catch {
//                            completion(.failure(error))
//                            print("try decoder.decode - success(result)")
//                        }
//                    } else {
//                        completion(.failure(NetworkError.urlSessionError))
//                        print("tcompletion(.failure(NetworkError.urlSessionError))")
//                    }
//                }
//            }
//        }
//        task.resume()
//        return task
//    }
//}


extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {

        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            
                if let error = error {
                   // completion(.failure(error))
                    fulfillCompletionOnMainThread(.failure(error))
    
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletionOnMainThread(.success(result))
                            print(#function, "try decoder.decode - success(result) - \(result)")
                        } catch {
                            fulfillCompletionOnMainThread(.failure(error))
                            print("try decoder.decode - success(result) 222")
                        }
                    } else {
                        fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                        print("tcompletion(.failure(NetworkError.urlSessionError))")
                    }
                }
            }
        }
        task.resume()
        return task
    }
}

