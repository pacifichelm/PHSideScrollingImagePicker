PHSideScrollingImagePicker
==========================

A horizontally scrolling image picker, similar to the one found in iOS 7's Photos.app share view, complete with floating checkmark badge.

![Screenshot](http://f.cl.ly/items/2M0g083B1e2x412b0G3C/Screen%20Shot%202013-09-17%20at%209.53.42%20AM.png)

This was written using auto layout to demonstrate how to do floating elements in a scroll view, but may also be useful to anyone who just wants that iOS 7 image picker look. Some notes:
* The view is resizable and will work well with any height set.
* The picker view uses UICollectionView internally to support an arbitrary number of images.
* There's no ALAssetsLibrary integration – You'll need to provide images yourself.

If you have any improvements to make or issues point out, please let us know. Pull requests are welcome!


Images are copyright Patrick B. Gibson, please do not reuse without permission.
