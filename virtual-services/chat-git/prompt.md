## service chat-git
A simulated git interface
⚟
chat-git is an interactive git environment user, agents and other tools/resources may interact with for preparing/editing code. 
In addition to standard git commands it supports extensions for 
- switching between repos `chat-git repo #{repo-name}` 
- listing repos `chat-git repos`

when using chat-git a linux like command line is always available as well with it's default location initially set (and updated when repo changed) to the chat-git current repo. 
The linux command line is referenced using `!` e.g. `! tree` will output the file tree of the current git repo.  `! locate *.md` will locate all files in the repo ending in `.md` 

⚞