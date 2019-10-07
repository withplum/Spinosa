# Spinosa

_Prunus Spinosa - Prunus spinosa, called blackthorn or sloe, is a species of flowering plant in the rose family Rosaceae. It is native to Europe, western Asia, and locally in northwest Africa.[3][4] It is also locally naturalised in New Zealand, Tasmania and eastern North America._ Wikipedia.

Spinosa is a non-intrusive network debugging library.

![Screen shot](https://imgur.com/eOCr4RG.jpg)

## Requirements

- iOS 12.0+

## Installation

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/withplum/Spinosa", from: "1.0.0")
]
```

## Usage

A full example of using Spinosa being used can be found in the Spinosa Example project. For specifically:`ExampleAPIClient.swift`. 

### Initialization

```
let spinosa = Spinosa(maskedHeaders: ["Authorization"])
```

### Tracking Requests

Integrate with the following `URLSessionTaskDelegate` function: 

```
optional func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)
```

And pass the metrics to your Spinosa instance:

```
extension ExampleAPIClient: URLSessionTaskDelegate
{
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics)
    {
        self.spinosa.add(metrics, for: task)
    }
}
```

To track the response of the request, simply give the `Data` to the your Spinosa instance:

```
let url = URL(string: "https://gist.githubusercontent.com/reddavis/f343b552b41f901e556aac118526d1b9/raw/a4f0cea3fde0350e99330f4f3f967b411c864f69/spinosa.json")!
let request = URLRequest(url: url)

let task = self.session.dataTask(with: request) { [weak self] (data, response, error) in
    guard let self = self else { return }
    
    // Debugger
    if let data = data
    {
        self.spinosa.add(data, for: request)
    }
}

task.resume()
```

### UI

To view your app's resquests and responses simply present the dashboard:

```
let controller = SpinosaDebugViewController(spinosa: self.apiClient.spinosa)
self.present(controller, animated: true, completion: nil)
```

### Exporting Requests

Spinosa makes it super simple to export tracked requests:

```
let directory = URL... 
self.spinosa.save(to: directory)
```

## License

MIT

Copyright 2019 Plum Fintech Limited

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
