HBaseLibrary
=============================

This is the utility library that I've used for my first foray into iPhone development: AllaKartor.se.

License
-----------------------------

All code is licensed under the New BSD License http://www.opensource.org/licenses/bsd-license.php except the following:

* OAuth http://www.apache.org/licenses/LICENSE-2.0
* entities.h and entities.c http://creativecommons.org/licenses/by-sa/2.5/

Strings
-----------------------------

The _HTMLDecode_ class provides a class method +string: that can be used to decode html entities in a string. The c-implementation comes from Stack Overflow: http://stackoverflow.com/questions/1082162/how-to-unescape-html-in-c and was written by Cristoph http://stackoverflow.com/users/48015/christoph

Caching
-----------------------------

There are two implemented cache types that implement the _HSimpleURLCache_ protocol: _HURLMemoryCache_ and _HURLFileCache_. These two can be used separately or in conjunction to store results from http requests. In my app I nested the memory cache in a file cache and only let the memory cache handle result data up to a size 20kB and a total of 500kB. The rest was only stored in the file cache.

Invalidation functions like max age et.c. are not implemented. The only invalidation is through -empty or -applicationDidReceiveMemoryWarning. A memory warning results in a -empty for the memory cache.

Image Loading
-----------------------------

The image loading classes provides functionality for asynchronous loading of images. 

_AsyncImageLoader_ is a utility class that takes care of the actual image loading and caching for the other classes. Object that are interested in status updates (-asyncImageLoader:imageDidLoad: & -asyncImageLoader:didFailWithError:) should implement _AsyncImageLoaderDelegate_ and be assigned as delegate.

_AsyncImageView_ is a subclass of _UIImageView_ that can load a image from a url, either through a call to -imageFromUrl: or by first calling -setUrl: and then -loadImageIfNeeded when the image is about to be shown. A activity indicator can optionally be enabled to show that the image is being loaded.

_AsyncImageTableCell_ is a subclass of _UITableViewCell_ that can be used to show images in a UITableView.

JSON
-----------------------------

This is taken directly from http://code.google.com/p/json-framework/

OAuth
-----------------------------

Almost all of the OAuth code is from the "official" objective-c implementation http://oauth.googlecode.com/svn/code/obj-c/. The exception is the _AuthorizationManager_ that's responsible for handling the OAuth workflow, and storing access and request tokens for the user.

REST
-----------------------------

The _RESTClient_ is a very simple client that only handles GET request so far, and assumes that all responses are JSON. The client handles authentication through a delegate that implements the _RESTClientDelegate_ protocol. A implementation for OAuth _OAuthRESTClientDelegate_ is already written.

There is a function for synchronous: -getResource:method:parameters:returningResponse:error: and asynchonous requests: -getResourceAsync:method:parameters:target:selector:failSelector: the selector is performed on the target on success, and the failSelector when the request fails.