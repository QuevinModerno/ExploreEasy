# Project Overview
ExploreEasy is a mobile application developed in Flutter aimed at enhancing tourism exploration across various locations. Adapted from an earlier Kotlin-based application, ExploreEasy allows users to discover and explore points of interest in specific cities, mountains, beaches, islands, or other regions, providing relevant information and an intuitive interface to navigate and interact with these locales. The app utilizes Firebase to store location data, enabling efficient access to updated information.

# Features
  Location Services: Retrieve the user's current location, with options to sort locations based on proximity or alphabetically.
  Interest Points: Users can view points of interest for each location, sortable by category, name, or distance.
  Anonymous Ratings: Users can anonymously rate locations as “Like” or “Dislike” and view aggregated ratings.
  Recent Searches: The last 10 locations viewed are saved locally, accessible via a dedicated screen.
  Data Persistence: Ratings and recent searches are stored using Flutter’s shared_preferences.
  Data Source: Firebase integration allows for seamless access to shared data across devices.

# Technologies Used
Flutter for UI and cross-platform development.
Firebase as the backend service for location data.
shared_preferences for local storage of user activity (ratings and recent locations).
Location package for accessing and managing the user’s current location.
