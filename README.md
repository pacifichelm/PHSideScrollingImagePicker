PHSideScrollingImagePicker
==========================

A horizontally image picker, similar to the one found in iOS 7's Photos.app share view, complete with floating checkmark badge.

Originally written using auto layout to demonstrate how to do floating elements in a scroll view, but may also be useful to anyone who just wants that iOS 7 image picker look. Some notes:
* The view is resizable and will work well with any height set.
* All the Auto Layout constraints are reasonably commented.
* There's no ALAssetLibrary integration – You'll need to bring that yourself.
* It's not doing cell reuse (it's not a table view), so there will be issues if you try to use it to load many large images at once.

Any improvements or issues, please let us know. Pull requests are welcome!


Images are copyright Patrick B. Gibson, please do not reuse without permission.