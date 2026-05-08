# Stock Market

An iOS application that displays real-time stock market data using the [YH Finance API](https://rapidapi.com/apidojo/api/yh-finance) from RapidAPI.

## Features

- **Stock List**: Displays a list of market stocks with symbol, name, current price, and change percentage.
- **Stock Detail**: Tapping a stock shows detailed information including trading data, market cap, P/E ratios, and company profile.
- **Auto-Refresh**: The stock list automatically updates every 8 seconds to reflect the latest market data.
- **Search**: Filter stocks by name or symbol using the built-in search bar.
- **Smart Change Calculation**: When the API doesn't provide change values directly, they are computed from current price and previous close.

## Screenshots

| Stock List | Stock Detail |
|:---:|:---:|
| List with real-time prices and change % | Detailed trading data and company info |

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern with the **Coordinator** pattern for navigation.

```
Stock Market/
├── Config/
│   └── APIConfig.swift              # API endpoints, keys, and URL builder
├── Models/
│   ├── Stock.swift                  # MarketQuote, FormattedValue models
│   └── StockDetail.swift            # StockQuoteDetail, SummaryProfile, StockDetailData
├── Services/
│   ├── NetworkService.swift         # Generic network layer with URLSessionDataProvider protocol
│   └── StockAPIService.swift        # Stock-specific API service with protocol
├── DI/
│   └── DependencyContainer.swift    # Dependency injection container
├── Coordinator/
│   ├── AppCoordinator.swift         # Navigation logic and route management
│   └── CoordinatorView.swift        # Root view wiring the NavigationStack
├── ViewModels/
│   ├── StockListViewModel.swift     # List state, search filtering, auto-refresh
│   └── StockDetailViewModel.swift   # Detail fetching and state management
├── Views/
│   ├── StockListView.swift          # Main list screen with search
│   ├── StockRowView.swift           # Individual stock row cell
│   └── StockDetailView.swift        # Detail screen with trading data
├── Preview Content/
│   └── PreviewHelpers.swift         # Sample data and mock services for SwiftUI previews
└── Stock_MarketApp.swift            # App entry point
```

### Layers

| Layer | Responsibility |
|-------|---------------|
| **Models** | Codable structs representing API responses |
| **Services** | Protocol-based networking (easily mockable for testing) |
| **ViewModels** | Business logic, state management, data transformation |
| **Views** | SwiftUI views with previews for all states |
| **Coordinator** | Centralized navigation management |
| **DI** | Dependency injection container for service creation |

### Design Patterns

- **MVVM**: Clear separation between UI and business logic.
- **Coordinator Pattern**: Navigation is managed by `AppCoordinator`, keeping views decoupled from navigation logic.
- **Dependency Injection**: All services are injected via protocols, enabling testability.
- **Repository/Service Pattern**: Network calls abstracted behind protocols (`StockAPIServiceProtocol`, `NetworkServiceProtocol`).

## Tech Stack

| Technology | Usage |
|-----------|-------|
| **SwiftUI** | Declarative UI framework with previews |
| **Swift Concurrency** | `async/await` for network calls, `Task` for auto-refresh |
| **Combine** | Reactive search filtering with `$searchText.combineLatest($stocks)` |
| **Swift Testing** | Unit testing framework |

## API

The app consumes the [YH Finance API](https://rapidapi.com/apidojo/api/yh-finance) via RapidAPI.

**Host**: `apidojo-yahoo-finance-v1.p.rapidapi.com`

| Endpoint | Purpose |
|----------|---------|
| `GET /market/v2/get-summary` | Fetches market summary with stock quotes |
| `GET /market/v2/get-quotes` | Fetches detailed quote data for a specific stock |
| `GET /stock/v3/get-profile` | Fetches company profile information |

> **Note**: The stock detail screen combines data from two endpoints (quote + profile) to provide a comprehensive view.

### Configuration

Set your RapidAPI key in `Stock Market/Config/APIConfig.swift`:

```swift
enum APIConfig {
    static let apiKey = "YOUR_RAPIDAPI_KEY_HERE"
}
```

> You can get a free API key at [RapidAPI - YH Finance](https://rapidapi.com/apidojo/api/yh-finance).

## Requirements

- iOS 17.0+
- Xcode 16.0+
- Swift 5.9+
- RapidAPI key for YH Finance API

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/fran2711/stockmarket.git
   ```

2. Open `Stock Market.xcodeproj` in Xcode.

3. Add your RapidAPI key in `Config/APIConfig.swift`.

4. Build and run on a simulator or device.

## Testing

The project includes **76 unit tests** organized into separate files by feature:

| Test File | Coverage |
|-----------|----------|
| `MarketQuoteTests` | Model properties, computed change fallback, FormattedValue |
| `ModelTests` | StockQuoteDetail display name, formatters, market cap, volume |
| `StockListViewModelTests` | Fetching, search filtering, auto-refresh lifecycle |
| `StockDetailViewModelTests` | Detail fetching, error handling, symbol storage |
| `StockAPIServiceTests` | Market summary, stock detail, error propagation |
| `NetworkServiceTests` | HTTP errors, decoding, headers, network failures |
| `AppCoordinatorTests` | Navigation path, route management, factory methods |
| `DependencyContainerTests` | Container creates ViewModels with injected dependencies |
| `NetworkErrorTests` | Error description formatting |
| `APIConfigTests` | URL construction and header configuration |

Run tests via Xcode (`⌘+U`) or from the command line:

```bash
xcodebuild test -scheme "Stock Market" -destination "platform=iOS Simulator,name=iPhone 17 Pro"
```

### Test Architecture

- **`TestHelpers.swift`**: Shared `MockStockAPIService` and mock extensions used across all test files.
- **`MockURLSessionDataProvider`**: Injected into `NetworkService` via `URLSessionDataProvider` protocol for reliable async testing.
- **`MockNetworkService`**: Injected into `StockAPIService` for service-layer testing.
- All tests use protocol-based mocks with no external dependencies.

## Previews

All views include SwiftUI previews with multiple states:

- **StockRowView**: Positive change, negative change, full list
- **StockListView**: Loaded list, loading state, error state
- **StockDetailView**: Full detail, loading state, error state
- **CoordinatorView**: Full app navigation

Preview data is provided by `PreviewHelpers.swift` with `PreviewStockAPIService` and sample models.

## Dependencies

**No external dependencies.** The project uses only native Apple frameworks:

- SwiftUI
- Combine
- Foundation

Dependency injection is handled via a lightweight custom container (`DependencyContainer`) using protocol-based design.

## Git Workflow

The project uses a feature-branch workflow:

- `main` — Production-ready code
- `development` — Integration branch
- `feature/*` — Individual feature branches merged into development

### Branches

| Branch | Description |
|--------|-------------|
| `feature/models` | Data models for API responses |
| `feature/networking` | Network layer and API service |
| `feature/dependency-injection` | DI container |
| `feature/viewmodels` | ViewModels with business logic |
| `feature/coordinator` | Coordinator pattern for navigation |
| `feature/views` | SwiftUI views and app entry point |
| `feature/unit-tests` | Unit test suite |
| `feature/readme` | Project documentation |
| `feature/api-refactor` | API layer refactor for working endpoints |
| `improvement/network-testability` | URLSessionDataProvider for testable networking |
| `feature/test-separation` | Tests split into feature-based files |
| `feature/view-previews` | SwiftUI previews for all views |
| `fix/price-change-fallback` | Computed change values when API returns null |
| `chore/project-config` | Gitignore and Xcode shared scheme |

## License

This project is for demonstration purposes as part of an iOS interview task.
