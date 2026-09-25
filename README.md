Product Catalog

A native iOS product catalog app using the free [DummyJSON Products API](https://dummyjson.com/docs/products). The planned app lets users browse products, search the catalog, load more results while scrolling, and view product details.

## Stack

- Swift
- UIKit with Storyboard for screen layout
- MVVM for separating screen behavior from UI code
- Foundation `URLSession` and `JSONDecoder` for API requests and JSON decoding
- iOS 18 or later

## Architecture

```text
Storyboard ViewController → ViewModel → ProductAPIService → DummyJSON
                                  ↓
                        Screen state and products
```

- **Models** describe products and paginated API responses.
- **ProductAPIService** makes list, search, and detail requests and decodes their responses.
- **ViewModels** manage loading, success, empty, and error states, as well as search and pagination.
- **ViewControllers and Storyboard** display the state, handle taps, and navigate between screens.
