# Cobox Task

## Task by Guy Chen

### In this project you are required to create a tab bar application with 2 tabs.

The first tab should present the following information:
 1. Your name
 2. The current Date and Time (should be updated dynamically every second)
 3. An Empty label (remember it!)

 - [X] I've create three labels in the `first` tab ViewController, first showing my name statically, other two get data dynamically therefor I've declared IBOutlets for them. See [FirstViewController](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/controllers/FirstViewController.swift)
 
The second tab should contain two segments in a segmented control:
 1. The first segment contains a table that will show the information received from this RSS feed "http://feeds.reuters.com/reuters/businessNews"
 2. The second segment contains a table which is a unification of the data received from "http://feeds.reuters.com/reuters/entertainment" and "http://feeds.reuters.com/reuters/environment". First the items from “Entertainment” should be presented, and then the items from “Environment”.
 - [X] I've created UITableView managed by [SecondViewController](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/controllers/SecondViewController.swift), presented data is changed on `valueChange` event of the `UISegmentedControl`, the default segment is the first one (business news).
 - [X] To load the data from unsecure (plain http) web service, I've configured the `NSAppTransportSecurity` in [Info.plist](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/Info.plist) for the given DNS only.

### You can parse the RSS feed using any method you like.
 - [X] I've created a custom parser [FeedParser](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/utils/FeedParser.swift) based on the built in `XMLParser`.
### Selecting a feed (a table item) will push a new view with the description of the feed.
 - [X] I've used a built-in `UIAlertController` for creating a view that shows the description of selected feed item.
### The application should now present in the empty label of the first tab (remember?), the title from the feed that was selected in the second tab.
 - [X] I've created a static property `FirstViewController.feedTitle`, that is used on `viewWillAppear` to show the last selected feed item.
### The application should check each RSS source (there are 3 RSS sources) every 5 seconds for an update and the UI should be updated immediately as soon as one of the RSS sources provided updated information. Taking into account the fact that the different RSS’s might have different response times.
 - [X] I've used 2 utility classes [AsyncTask](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/utils/AsyncTask.swift) and [Api](https://github.com/nikitaKurtin/cobox/blob/master/CoBoxTask/utils/Api.swift). `AsyncTask` helps to handle all requests and parsings asynchronously in OO approach. `Api` helps to manage all urls as well as potentially needed request specifications (in this case only `HTTP GET`). 
### Whenever the application checks for update, it should show an activity indicator that does not block the screen or the user from interacting with the application.
  - [X] I've added `UIActivityIndicatorView` in the `SecondViewController` which shown every time the data is starting to load and since loading and update asynchronously (as stated above) it doesn't block the screen.
### Keeping good design and documentation standards.
  - [X] I've kept naming convetions as consistent and readable as possible, as well as added many comments to make it even clearer.   
