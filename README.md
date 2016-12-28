# AC3.2-GoodGirlOrBoy
Behavior tracking with Core Data (That's "behaviour" for Tom)

# Backstory

Let's just imagine, hypothetically, that you have three young boys. It's 
winter break. It's gettin' kind of crazy being trapped inside. The tight
working schedule that seemed so stressful before is looking strangely 
appealing now.

But you have software development super powers. Surely they can be applied
to the situation. After some contemplation (and maybe a lobotomy, you 
can't remember), you've come up with the following solution.

# Objective

Build an app to record good and bad behavior. At the end of each day
you can show each kid how he did. (Psychology Pro Tip: Probably best to only
reinforce the positives with the kids but you still want to record
negative behaviors for your own tracking purposes. After all, a downward
trend of negative behaviors is a good thing.)

# Elements

(No, no more chemical elements, I promised.) I say elements because we don't need
steps anymore, do we? Do _we_ need a behavioral app...? 

* The usual fork and clone.
* Create a new project and check the Core Data box.
* Use Cameron's Coffee Log app and the Midunit Assessment as references.
* The basic _Entity_ in your app will be a Behavior Event. It must capture the following
  data: a timestamp, the child's name, the observed behavior, whether the behavior was a good or bad
  (ahem, prosocial or antisocial)
* At the barest minimum you could hard-code a child's name and a default behavior message and display
  a plus and minus button in the nav bar (just adding a minus button to the Coffee Log). The table would
  populate immediately on tapping + or -.
* For a more complete solution, the plus button should present (or push onto the navigation stack if
  you don't know how to present) a view controller with entry TextFields for the behavior and the name.
  To keep your data clean you could predefine a list of names and behaviors and put them in pickers.
* If you really want to be organized you can put the kids and the basic behaviors into other Core Data
   entities and use them to populate pickers. But start with populating the pickers from hard coded 
   arrays.
* You could create a filter on the list of behaviors that filter by kid, by pro/anti social, and by day.
  The day filter might be easiest to just do today/all. All of these filters could work in combination.
  *cough*NSPredicate*cough*.

Note: The Coffee Log app did a bit of fancy footwork with trapping the creation of an object 
and setting the timestamp. I think the way we parsed out Elements and inserted them a week ago in the
Core Data review (or how you were to do it on the Midunit assessement), creating a new Entity and then
populating its fields, is more straightforward and appropriate for this case.

If you're at a loss for pro- and anti- social behaviors, here's a list that comes immediately to mind.
Extra credit if you know which are the prosocial behaviors.

* throwing
* running in the house
* sharing
* clearing the table
* finishing dinner
* hitting
* saying thank you
* biting
* apologizing (Sorry, Tom, I apologise)
* doing homework
