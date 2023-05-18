# nomad

Nomad is a forthcoming social media application that is being developed with the aim of connecting users through shared experiences, events, and exploration. It is being designed to provide a range of exciting features, including finding and creating events, connecting with friends, discovering new places, and promoting events. With a strong focus on user interactivity, Nomad aims to create an engaging and dynamic platform for socializing, exploring, and organizing events. The app is being developed to revolutionize the way people socialize, explore, and engage with events, offering a unique and captivating experience for users of diverse interests.

## Setup

Before running the application, make sure to set up your API keys for Google Maps and Google Places. Follow the steps below:

1. Create a `.env` file in the root directory of the project.
2. Open the `.env` file and add the following lines:

``` sh
GOOGLE_MAPS_API_KEY="<YOUR_GOOGLE_MAPS_API_KEY>"
GOOGLE_PLACES_API_KEY="<YOUR_GOOGLE_PLACES_API_KEY>"

```


Replace `<YOUR_GOOGLE_MAPS_API_KEY>` and `<YOUR_GOOGLE_PLACES_API_KEY>` with your actual API keys from Google Cloud Console.

## Getting Started

This project is a Flutter application that allows you to explore maps and places. It serves as a starting point for building your own location-based applications.

To get started with Flutter development:

1. Install Flutter by following the [official documentation](https://flutter.dev/docs/get-started/install).
2. Clone this repository: `git clone https://github.com/your-username/nomad.git`.
3. Navigate to the project directory: `cd nomad`.
4. Retrieve the dependencies by running: `flutter pub get`.
5. Run the app on your preferred device or emulator using: `flutter run`.

For more information on Flutter development, refer to the [online documentation](https://flutter.dev/docs), which provides tutorials, samples, and a full API reference.

## Features

- Explore with a map and discover new places.
- Find and join events created by others.
- Create and organize your own events with your friends.
- Connect with friends and share and organize events through realtime messaging
- Purchase event tickets and browse promotions.
- Get personalized recommendations based on your interests and location.
- Ability to view a place's event history, photos, and videos, to allow users to gain insights and a better understanding of a place's atmosphere and appeal.

## Directory Structure

The project follows a standard directory structure to maintain organization and modularity. Here's an overview of the directories and their purposes:

- `lib`: Contains the main application code.
- `models`: Includes data models and structures used within the app.
- `screens`: Contains the different screens or pages of the app.
- `services`: Includes service classes for handling API requests and data management.
- `widgets`: Contains reusable UI components used throughout the app.

Feel free to explore and modify the code to suit your needs.

