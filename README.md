SlideGesture
============

An iOS class to implement a slide accessory to table view cells similar to the one in iOS 7 Mail app

This class, SMSlideGestureRecognizer was written to provide a similar slide button interface used in the iOS 7 Mail app.  

The design goals are:
   1. Clean design consistent with the look of iOS 7
   2. Simple for the programmer to use
   3. Consistent with Apple best practices and HIG
   3. Works in iOS 6 as well as 7
   4. Works with all views that allow the programmer to add a gesture recognizer
   5. Flexible and configurable size, number of buttons, color and label of buttons

The current version 0.0.2 does not satisfy all of the goals.

The presentation is clean and simple.  The slide is smooth and reliable.  The slide operation is a little different than the iOS 7 Mail app.  Mail slides and uncovers the buttons, this slides the buttons on to the view.  There is also a little bounce that signifies it has completed the open or close.  

The interface is the same as for any other UIGestureRecognizer class.  You instantiate an instance and add it to the target view specifying the target and action in the init method.  Then you do any additional configuration necessary and add it to the view.  The action method follows the same guidelines for any other recognizer. 

The consistency with Apple best practices and HIG is not as total as I would like, but it is not far off.  The glaring deviation is that when attached to a table view cell that has an accessory view, you must add the recognizer to the scroll view that is the superview to the content view.  Apple states that all added items in cells should be added to the content view.  At this time I am not certain if this can be changed.

This class does not present properly in iOS 6.  This should be a minor change but I am no longer supporting 6 so may not do it.

So far I have tested the class on a regular UIView, UIButtonView, and UITableViewCell.  It works properly in those cases as long as the width of the view is sufficient to allow the slider to be opened.

The flexibility is the last part to complete.  Stability and reliability has been a higher priority than the flexibility.  The only configurable parameter so far is the width of the slider. 
