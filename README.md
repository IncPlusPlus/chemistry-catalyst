# Chemistry Catalyst

A chemistry multi-tool made for chem class and for fun

## What can I run this on and how?
You can run this on any device with a web browser by visiting [this link](https://chem-catalyst.herokuapp.com/). If you're on an Android device, and you're comfortable downloading a `.apk` file, download `app-release.apk` from the [releases page](https://github.com/IncPlusPlus/chemistry-catalyst/releases). Or to do less clicking, [here's](https://github.com/IncPlusPlus/chemistry-catalyst/releases/latest) the latest release and [here's](https://github.com/IncPlusPlus/chemistry-catalyst/releases/latest/download/app-release.apk) the latest APK.

Personally, I recommend using a mobile device because that's where it looks best. There's just too much unused space on a big screen and it makes my project look ugly ;-;

## How do I use it
Open the application (open the app if you've installed it, otherwise, go to the web link specified in the section above). Next, visit one of the tools that have been implemented so far by clicking on the "hamburger menu" icon at the top left. A navigation drawer will open. Click on one of the tool's names to go to that tool.

## The tools
This project sports a meager three tools. However, I'll argue that it really has six because the second and third tools have multiple ways to use them.

### Molar Mass
This tool lets you find the molar mass of any element or compound. Simply click the '+' button to add more elements. Then, specify the number of moles of that element are in your compound.

### Grams <-> Moles
This tool lets you find the amount of a given element or compound in moles when you provide an amount in grams. You can also provide an amount in moles and get how many grams of your compound or element that is. Adding elements to form a compound here is the same as described above.

### Solutions & Molarity
This tool is useful for calculating different variables of a solution. It's a lot like the one found at [GraphPad](https://www.graphpad.com/quickcalcs/molarityform/).

Here are the three scenarios you can use it for:
- You have an element/compound, a concentration (in molarity), and the volume of the solution
  - The tool calculates the mass of the dissolved solute
- You have an element/compound, the mass of the solute in the solution, and the volume of the solution
  - The tool calculates the concentration of the solution (in molarity)
- You have an element/compound, the mass of the solute in the solution, and the concentration (in molarity)
  - The tool calculates the volume of the solution

To specify the element (which you may have observed is a required component for all 3 scenarios), follow the same method as the above two tools.

## Known issues
See [here](https://github.com/IncPlusPlus/chemistry-catalyst/issues) for known issues. The biggest one right now is that the subscripts in empirical formulas turn into rectangles with an X through them. This doesn't happen in the Android app or if you access the website through a mobile device.

## Retrospective and other tidbits
This project was _way_ more ambitious than what I was actually capable of at the time. This semester was pretty rough for me in terms of my personal life. On top of that, I'm still super rusty with Flutter (the framework I used to build this app) which means that I was fiddling around a lot and learning while I coded. While this isn't a bad approach to learning, it's a bad approach to getting work done for an impending deadline.

Overall, I'm satisfied with where I managed to get this project. In the next few days after the deadline, I might actually complete another tool or two just for fun.