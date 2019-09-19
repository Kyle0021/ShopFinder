# ShopFinder
- A framework downloads, stores, manipulates and sends back all the data.
- The App calls the framework methods to get all the data that is displayed in the app.

Uses a custom built framework included in the project called, ShopFramework, to retrieve all data objects. This framework is bundled with the app. You should be able to download the project and run it without any errors. If Xcode has trouble finding the framework, use the standard "Link Binary With Libraries settings to add it, found under "Targets-ShopFinderApp-Build Phases- Link Binary with Libraries", and/or try to add the frame in "Targets-ShopFinderApp-General-Embedded Binaries"

- View a list of cities, 
- Select a city and see all the malls inside that city.
- View a list of shops in the selected mall
- View all shops in a city
- Search cities, malls, and shops by ID
- App can be used offline, as it stores the latest data from the last internet connected session.

![First Screen - List of cities](https://github.com/Kyle0021/ShopFinder/blob/master/Gif_sample.gif)
![App icon on Home Screen - List of cities](https://github.com/Kyle0021/ShopFinder/blob/master/App%20Icon.png)
