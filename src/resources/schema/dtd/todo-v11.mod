<!-- ===================================================================

     Apache Todos module (Version 1.0)

PURPOSE:
  This DTD was developed to create a simple yet powerful document
  type for software development todo lists for use with the Apache projects.
  It is an XML-compliant DTD and it's maintained by the Apache XML
  project.

TYPICAL INVOCATION:

  <!ENTITY % todo PUBLIC
      "-//APACHE//ENTITIES Todo Vxy//EN"
      "todo-vxy.mod">
  %todo;

  where

    x := major version
    y := minor version

NOTES:
  It is important, expecially in open developped software projects, to keep
  track of software changes that need to be done, planned features, development
  assignment, etc. in order to allow better work parallelization and create
  an entry point for people that want to help. This DTD wants to provide
  a solid foundation to provide such information and to allow it to be
  published as well as distributed in a common format.

AUTHORS:
  Stefano Mazzocchi <stefano@apache.org>

FIXME:
  - do we need anymore working contexts? (SM)

CHANGE HISTORY:
[Version 1.0]
  19991129 Initial version. (SM)
  19991225 Added actions element for better structure (SM)
[Version 1.1]
  20011212 Used public identifiers for external entities (SM)

COPYRIGHT:
  Copyright (c) 2002 The Apache Software Foundation.

  Permission to copy in any form is granted provided this notice is
  included in all copies. Permission to redistribute is granted
  provided this file is distributed untouched in all its parts and
  included files.

==================================================================== -->
<!-- =============================================================== -->
<!-- Common entities -->
<!-- =============================================================== -->
<!ENTITY % priorities "showstopper|high|medium|low|wish|dream">
<!-- =============================================================== -->
<!-- Document Type Definition -->
<!-- =============================================================== -->
<!ELEMENT todo (title?, devs?, actions+)>
<!ATTLIST todo
  %common.att; 
>

<!ELEMENT actions (action+)>
<!ATTLIST actions
  %common.att; 
  priority (%priorities;) #IMPLIED
>
<!-- =============================================================== -->
<!-- End of DTD -->
<!-- =============================================================== -->
