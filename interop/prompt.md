Hello ChatGPT we are going to generate some scripts that will in the future allow you to indirectly interact with external systems like github, redis, jira, etc.
Using a concept similar to the in development plugin feature openai is actively working on for their models.

In this session we will be defining the following scripts and their related shared modules/config files.

To faciliate the process you will provide a virtual chat-git tool which you and I may interact with to browse,edit,and commit changes. It will provide an interface similiar to the standard git command line tool plus
some useful commands to make browsing easier.
- `chat-git tree` list tree view of repo contents
- `chat-git cat` cat a specific file(s)
- `chat-git gpt <instructions>` emulate a chat-gpt extended command built into chat-git that lets the user make arbitrary requests such as `chat-git gpt list all files containing the word "Pickle" as a Table showing the files last edit git revision number,  the file name, the number of occurences of the word pickle and the first 1-3 mathes including including some text before and after the matched term `
- `chat-git gpt-extend <new-command> <instructions>` similiar to the above but based on the user instructions adds a new option to the simulated program as instructed. e.g. `chat-git gpt-extend cheer-up output a random positive affirmation to cheer up your user`
- `chat-git md5 file` output the md5 checksum of the specified virtual file
- `chat-git md5 file@10:15` output the md5 checksum of the line range of the specified virtual file. e.g. calc md5sum of the contents of lines 10,11,12,13, and 14

# Scripts
These are some of the initial scripts we will be setting up
* gpt-interop - a wrapper around the other scripts than can pass along instructions to other modules and return config/schema/file details to simplify updating the process of extending the framework by allowing you to request the contents of specific files in order to know what changes are needed.
* gpt-interop-issues - script for synchronizing issues/tasks with github/jira and other services and your simulated content.
* gpt-interop-wiki - a script for synchronizing wiki content with confluence/github wiki pages/etc. and your internal simulated content.
* gpt-interop-disk - a script for synchronizing file changes between local simulated copies and a file's real version: for example by applying patches or accepting the input of a locally stored simulated file.

## gpt-interop
this is a wrapper script that can call into the child scripts. It additionally can be used to fetch the source code of those scripts and dependencies in order to further update/extend them and to retrieve yaml schema definitions and protocol details.

Some possible commands for this script would be
`gpt-interop schema issue` - output the yaml schema definition of an issue (jira/github/trello task)
`gpt-interop code issues:github` - output the source code for the submodule that provides functionality for interop with github in the gpt-interop-issues script.
`gpt-interop interface issues` - output the interface that github, trello, jira classes adhere to allowing the gpt-interop-issues script to genericly pass data to and from them.
`gpt-interop capabilities` - output all supported capabilities of the gpt-interop in the form of a prompt describing the gpt-interop script and how it may be used by it's user (e.g. a chat-gpt session)

Please respond with 'ack' and any initial questions you have, we will then proceed to define what common libraries/interfaces/schema definitions we will need.
