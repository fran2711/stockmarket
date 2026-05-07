# Stock Market

An iOS application that displays real-time stock market data using the [YH Finance API](https://rapidapi.com/apidojo/api/yh-finance) from RapidAPI.

## Features

- **Stock List**: Displays a list of market stocks with symbol, name, current price, and change percentage.
- **Stock Detail**: Tapping a stock shows detailed information including trading data, market cap, P/E ratios, and company profile.
- **Auto-Refresh**: The stock list automatically updates every 8 seconds to reflect the latest market data.
- **Search**: Filter stocks by name or symbol using the built-in search bar.

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
│   └── StockDetail.swift            # StockDetailResponse, StockPrice, SummaryDetail, SummaryProfile
├── Services/
│   ├── NetworkService.swift         # Generic network layer with protocol
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
└── Stock_MarketApp.swift            # App entry point
```

### Layers

| Layer | Responsibility |
|-------|---------------|
| **Models** | Codable structs representing API responses |
| **Services** | Protocol-based networking (easily mockable for testing) |
| **ViewModels** | Business logic, state management, data transformation |
| **Views** | SwiftUI views, purely declarative UI |
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
| **SwiftUI** | Declarative UI framework |
| **Swift Concurrency** | `async/await` for network calls, `Task` for auto-refresh |
| **Combine** | Reactive search filtering with `$searchText.combineLatest($stocks)` |
| **Swift Testing** | Unit testing framework |

## API

The app consumes the [YH Finance API](https://rapidapi.com/apidojo/api/yh-finance) via RapidAPI:

| Endpoint | Purpose |
|----------|---------|
| `GET /market/v2/get-summary` | Fetches market summary with stock quotes |
| `GET /stock/v2/get-summary` | Fetches detailed data for a specific stock |

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

The project includes unit tests covering:

- **Model Tests**: Property accessors, computed properties, fallback values.
- **ViewModel Tests**: Data fetching, error handling, search filtering, auto-refresh lifecycle.
- **DI Tests**: Container correctly creates ViewModels with injected dependencies.
- **Config Tests**: URL construction and header configuration.
- **NetworkError Tests**: Error description formatting.

Run tests via Xcode (`⌘+U`) or from the command line:

```bash
xcodebuild test -scheme "Stock Market" -destination "platform=iOS Simulator,name=iPhone 17 Pro"
```

### Test Architecture

Tests use a `MockStockAPIService` that conforms to `StockAPIServiceProtocol`, allowing full control over responses without network calls.

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

## License

This project is for demonstration purposes as part of an iOS interview task.
