# Trans48+

AKB48 Google+ Translation Helper iOS Application

Final Project of Udacity iOS Nanodegree course

Trans48+ is an iOS Swift application that let you browse AKB48 group, Japanese girl idol group, members' Google+ posts, translate the content and share the translation via iOS's integrated share activity.
In the 1st version, Trans48+ enables browsing Google+ posts of HKT48, part of AKB48 group, members. Other group members will be added in the future version.

## Intended user experience

### Translation
* 1.Upon loading, user is presented with a list of HKT48's members.
* 2.User selects a member to view her most recent Google+ posts.
* 3.User selects a post to see content and photo.
* 4.User tabs "Translate" icon on the top right to enter translate screen, which has original content in Japanese on the left and blank textbox on the right.
* 5.User translates the content to his own language on the right textbox.
* 6.User tabs "Share" icon on the top right and share the translated content via iOS share activity.

### Favorite
* 1.Upon loading, user is presented with a list of HKT48's members.
* 2.User selects a member to view her most recent Google+ posts.
* 3.User tabs "Star" icon on the top right of the screen.
* 4.User navigates back to the Member list
* 5.User tabs "Liked" button on the top left
* 6.User sees only the members he liked. He can then follow her updates easily.

## Features

* Use Google+ API to load HKT48 member's information, post and photos
* Load new posts every time the user clicks on member to view posts
* Like/unlike member
* Manually translate member post and share to the social
* Auto save translated content
* Navigate through previous/next post in the post view
* Tap on the photo in the post to open photo view in almost full screen
* Save photo in full, uncompressed resolution
* Cache loaded photos to view offline

## Limitation

* Due to Facebook policy, you cannot share translated content via the activity view controller. Sharing to Facebook is limited to the original Google+ post URL. Therefore I recommend you share to Twitter or Email to get translated content, original post URL and full resolution photo.

## Instruction

* This application requires Google+ API key. I have registered mine in the application but in case it doesn’t work, you need to obtain a key from https://developers.google.com/+/web/api/rest/oauth#acquiring-and-using-an-api-key
* Register your key in Constants.swift: Constructs.GooglePlusApi.ParameterValues.Key
* Compile with XCode 7.3/ Swift 2.2
