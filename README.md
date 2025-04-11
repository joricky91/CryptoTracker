# 🚀 Crypto Tracker App

This is a crypto tracker app created by following the course from [@SwiftfulThinking](https://www.youtube.com/@SwiftfulThinking) 
YouTube course: 📺 [Crypto App Tutorial Playlist](https://www.youtube.com/watch?v=TTYKL6CfbSs&list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu)

## 🛠 Tech stack
- **Swift Language**
- **SwiftUI**
- **Combine**
- **CoreData**
- **Swift Concurrency**

## 📌 Key Differences from the Original
- While the original project uses Combine for networking, I implemented Swift Concurrency (async/await) instead. I used the concurrency because I want to deepen my understanding of modern concurrency in Swift.
- I also used some new SwiftUI API from iOS 15+, such as .refreshable modifier to implement pull to refresh on the cryptocurrencies list.

## 📊 Data Source
The app fetches real-time cryptocurrency data from the [CoinGecko](https://www.coingecko.com/) API.
