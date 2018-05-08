# DySi Open
**DySi Open** uses Dynamic Signals open api to load posts.

Time Spent: Friday May 4 to Tuesday May 8

## Tasks
- [x] Create a new empty project in Xcode.
- [x] Setup Git for this project and link it to your personal account, make a
  first commit.
- [x] Using a framework of your choosing (native or 3rd party), make a call to
  [Dynamic Signals public api](https://www.dysiopen.com/v1/posts/public). The
  response will be a JSON array of post objects. You can see what these objects
  look like [here](https://dev.voicestorm.com/api/responses/postResponse).
- [x] Using Texture framework, render the following for each post:
    - [x] author (including profile image if it exists)
    - [x] title
    - [x] description
    - [x] creation date
    - [x] post’s image (if exists in the “media” array)
- [x] Clicking on each post should open the post’s "permalink” in a webView.
 
## Bonus (Nice to have features):-
- [x] Implement pull-to-refresh.
- [x] Implement caching mechanism for the server response: With `Alamofire`
- [x] Implement caching mechanism for images: With `PINCache`

## Extra features I've added
- [x] User sees an alert when there's a networking error.
- [x] User sees a loading state while waiting for posts to load.
- [x] User sees images being rendered progressively as it gets downloaded.
- [x] User sees Launch Image when they open the app
- [x] User sees empty table message when the table does not have any posts to
  show. User will not see empty table cells.
- [x] User sees progress indicator at the bottom of the screen signifying a
  loading page when the web page of the permalink is being loaded
- [x] Not a feature (actually a discouraged action): overrode SSL requirements
  so users can view resources from links that use `HTTP` (since there were
  images that used `http`)

## Unit testing done for
- [x] Utils/ErrorHandler
- [x] Models/DySiPost
- [x] Models/DySiPostAuthor
- [x] ViewControllers/ViewModels/AllPostsTableViewModel
- [x] ViewControllers/ViewModels/PostTableNodeCellViewModel

## Things I would like to have but am unable to for now due to time constraint
- [ ] Testing for Managers/DySiDataManager
- [ ] Higher test coverage
- [ ] UI testing

> Feel free to surprise us with anything cool you can do to this project.

Here’s how are we going to assess the project:-

- Having a **well thought design** for your code, that is **maintainable**,
  **testable** & **clear**.
- **Documented methods**, variable & class names that are meaningful.
- A good commit history.
- A neat UI that should look decent and work on **different screen sizes** +
  **landscape mode**.

You are welcome to use as many 3rd party libraries/pods as you wish.

