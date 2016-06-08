[![Build Status](https://travis-ci.org/OlehKulykov/RM_.svg?branch=master)](https://travis-ci.org/OlehKulykov/RM_)
[![OnlineDocumentation Status](https://img.shields.io/badge/online%20documentation-generated-brightgreen.svg)](http://olehkulykov.github.io/RM_)

## Project directory structure
Current project directory structure conforms [Model-View-Controller][1] design pattern (MVC), plus extra project specific **Supporting Files**:

- **Model** - _Application’s data and the logic that manipulates that data._
  - **[Core Data]** - _Manipulation logic, data model, managed objects, etc._
    - **[Core Data] Stack** - _Stask that manipulates with context and low level managed objects._
    - **DAL** - _[Core Data] Layer that operates with top level objects, such as User's, Product's, etc._
    - **Managed Objects** - _Top level managed data model objects, such as User's, Product's, etc._
    - **Specific DALs** - _Extra functionality of the standart DAL's._
  - **Parser** - _Available parsers and converters._
  - **Misc** - _Miscellaneous, common model functionality._
- **View** - _View object's that displays and allows users to edit, the data from the application’s model._
- **Controller** - _Intermediary level between the application view objects and its model._
- **API** - _Application network communication layer._
    - **Base** - _Basic network requests._
    - **Misc** - _Network common functionality._
- **Supporting Files** - _Application resources, settings, image assets, etc._
  - **Fonts** - _Custom application fonts._


## Code commenting
Code commenting style conforms [Apple Markup Format][3] that allows to generate [documentation][4] from code comments.

This [documentation][4] generates using [jazzy][5] command-line utility after passing all tests on [Travis] continuous integration service.



[1]:https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/Model-View-Controller/Model-View-Controller.html
[Core Data]:https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/index.html
[3]:https://developer.apple.com/library/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
[4]:http://olehkulykov.github.io/RM_
[5]:https://github.com/realm/jazzy
[Travis]:https://travis-ci.org/OlehKulykov/RM_
