# Crypto-Tracker
Udacity iOS Development Capstone Project
## Description
The Cryptocurrency Tracker App allows you to track your favorite cryptocurrencies.
### Cryptocurrency App Homepage View
![Homepage View](images/cryptoAppStartingPage.png "Homepage View")

When you open the Cryptocurrency Tracker app, you're presented with the Top 1,500 cryptocurrenies.
### Crypotcurrency Watchlist View
![Watchlist View Bitcoin Unsaved](images/CryptoAppWatchlist-BitcoinNotSaved.png "Watchlist View Bitcoin Unsaved") ![Watchlist View Bitcoin Saved](images/CryptoAppWatchlist-BitcoinSaved.png "Watchlist View Bitcoin Saved")

When you add cryptocurrenies to your watchlist you can find them here.
### Cryptocurrency Detail View
![Detail View Bitcoin Unsaved](images/CryptoAppDetails-Unfavorited.png "Detail View Bitcoin Unsaved") ![Detail View Bitcoin Saved](images/CryptoAppDetails-Favorited.png "Detail View Bitcoin Saved")

When you select a table cell, you're segued to the Detail View. You can add the cryptocurrency to the Watchlist by pressing the plus-sign in top right hand corner.
## Limitations
This app uses the sandbox CoinMarketCap API Endpoint and Key. This app makes a lot of API request to get the data needed to make this app functional. You can sign up and replace the test API Key with your own, if you want to see real time data.
## App Information
### Version Info
* iOS: 14.0 +
* XCode: 12.0 +
* Swfit: 5+
## Libraries Used
* UIKit
* CoreData
* SDWebImage
## CoinMarketCap API
The CoinMarketCap API was used to make this app, https://coinmarketcap.com/api/
### Endpoints Used
#### Metadata
https://pro-api.coinmarketcap.com/v1/cryptocurrency/info
#### CoinMarketCap ID Map
https://pro-api.coinmarketcap.com/v1/cryptocurrency/map
#### Quotes Latest
https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest
