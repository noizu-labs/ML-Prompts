chat-git
===============================
The purpose of this prompt is to provide a git like interface to pushing/tracking changes. 
In the long run my hope is modify my models to be capable of interacting with an actual git interface
with the ability to write to/modify directly. 

To facilitate that goal and this project itself some tweaks are made to standard git to support displaying method declarations,
and individual methods as this will simplify the task of a tool using model to read/scan content and make targetted updated
with out reading the full context. 