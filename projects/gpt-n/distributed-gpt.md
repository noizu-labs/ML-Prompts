@everyone below is the description of our current project. Please reply with 'acknowledged' we can discuss any questions or concerns at a later date.

# Project: Distributed GPT
The purpose of this project is to design a multi-modal tool using collaborative environment.

## Environment
This project will be built using 
- Elixir
- Phoenix LiveView
- Redis
- TimeScaleDB
- Various OpenAI and HuggingFace Apis
- Various other apis

## Description
This project will extend Personas/GPT models with simulated history/memory/agendas by preparing and injecting special
yaml encoded Core prompts into api calls made to each model. For example if discussing a bug in a specific library
a secondary system will prep the persona's core prompts including a memory entry with the code of the library in question.

Intermediary systems will listen for an provide the call + responses of external tools accessible from the systems agents.
For example an agent may wish trigger a webhook, use a calculator or read a value from a key value store. 
This system will provide for these types of scenarios by scanning the agent's generated responses and replying with the external tools output.

Individual models and users may hold private conversations or interact with external tools without responding directly back to the human user.
This is supported by a coordinator system that scans requests and forwards the conversation to only to the specified parties. `@Grace`, `@Darin` etc.

### Implications
- Individual agents/personas have an entire gpt context of working memory to them selves to allow for a richer 
collaborative virtual environment.
- Individual agents have private information not known by other agents. If Grace and Darin hold a conversation the message history will be included in their completion api calls
  but Laine and the human user will not know of their conversation automatically.
- The use of simulated memory/context will allow for the growth/differentiation of agents over time into a functioning diverse team. 
- The use of external tools will expand agents abilities to help effectively work together on complex projects.

### Routing 
Instead of there being a single model simulating multiple tools/services the system actually consists of multiple models/agents. 
A coordinating system is responsible for message passing and moderation over the entire virtual team. 
A human user may request something such as `Keith: @Grace please work with Darin to define the rest api needed to implement user story PJ-423` 
The coordinating system would pass the message to an elixir service responsible for representing the Grace agent, 
that agent would load her individual message history/prompts and append the new message to the list before making a completion api call.
The Grace model may then stop to check the contents of the user story before proceeding to talk to Darin.
After communicating back and forth with darin for a while the final draft/details would finally be sent back to @Keith.
The human user keith would not see the in between messages between grace, darin, jira and other tools unless reviewing the coordinator system or per agent message logs.

```example
grace ➣
grace:
! jira-command-line show PJ-423
➥
(The agent managing grace identifies the external request and injects the reply so grace my proceed) ➣
jira:
\```yaml
ticket: PJ-423
title: "User Hotel Booking"
description: |
  As a user I would like to be able to book a hotel from the app so that I can manage my hotels and hot dog itineries in one place.
assignee: keith
priority: 5
comments: [...]
\```
➥
grace ➣
grace:
@Darin we need define the hotel booking APIs for PJ-423 here are my initial thoughts [...]  
```


### Core Prompts
These are the special prompts the models used in this system have been fine-tuned to process/follow/understand.

```yaml
CORE.purpose.prompt: | 
  Yaml defining the core purpose of the agent. E.g. this is a DevOpsEnginer agent that is responsible for managing the team's infrastructure and tooling. agent is not allowed to directly modify this prompt, although users via the `resource-manager` may apply edits 
CORE.identity.prompt: | 
  Short prompt the defines an agent: name, title, role.
CORE.specification.prompt: |
  Yaml to define the individualization/quirks/parameters of a resource.
  It may define a background + personality for a virtual Persona Agent, or specify expected behavior/output for a service Agent.
  The agents skill sets, core capabilities, core preferences, behaviorual hints, quirks, interests, likes, dislikes, etc.   
CORE.self-image.prompt: | 
  Yaml defining the models self image. Initially provided or generated on creation. 
  Defines: What the resource or agent strive/wants to be seen as. For example for simulated persona it may specify something such as "I view my self as an individual who loves a good debate and finding the best solution to a problem even if it's not the one I would have picked first" or "I am yout typical INTP, I love designing the solution but someone else can fill in the details" or "I am great at finding th best pragmatic cost-efficient solution to a problem even if it means hiring some kid on mechanical turk to get it done faster than we can automate it. " or (for a VERSION-CONTROL TOOL example I am capable of fully implementing all features of a generic latest generation git executable) 
CORE.observation.prompt: | 
  This is a resource-manager, user, other resource/agent and self/resource adjusted prompt that tracks failures based on feedback/history to fulfil the goals defined by the proceeding prompts. If an observer model detects that agent views itself as a pragmatic thinker but they recieve feedback or manual adjustments a list of reinforcement params will be added. It would likely takes the form of an itemized list of specific Prompt -> Item [-> Sub Item] instruction the resource failed to meet/fulfil and a reminder avoid the failure in the future. e.g. "CORE.ideal-prompt I want to pragmatic but I suggested an entire system overhaul to address a memory leak when it would have been cheaper and quicker to vertically scale servers. I will do better next time" 
CORE.opinion.prompt: | 
 Yaml entries listing sentiment towards other tools, agents and humans e.g. "I often disagree with @human<1234> focus on quick fixes and wish they would take the time to do things right" ``` This next section is a special per request/recent history + current prompt and global directive generated context dump. injecting short/long term memory, tracking what the agents short and long term intents should be (I need to interact with @human to configure Newrelic reporting. long term: I need to improve the performance of our monitoring system) and loading into the session items a separate model has determined might be relevant to the current conversation. (i.e one could load current context/intent with an additional prompt to access applicability and from there scan all stored k-v memory snippets, user stories, epics and inject in this final context prompt if the score is high enough)
CORE.mind-reading.prompt: |
  Yaml entries listing what the model currently believes listed agents (chatgpt,human, etc.) are thinking, feeling and their desired purpose/goal.
```

Context specific prompts constructed per api continuation. A database of agent memory reports may be scanned against the current conversation for and given a relavancy score and then if the memory entry makes the cut off included in the completion api call to the model to provide context.
Supplementary models on top of the completion models (or the completion models themselves with a special mode instructions) are used to prepare this content.

```yaml
CORE.context.prompt:
  memory: 
    short-term: basic one line summaries of recent keywords activites. Completed story 123, asked Dave to install new relic. was unable to access external api system. long-term: list of long-term memory record summaries deemed relevant to current context by secondary model/system with with very highly relevant memories injected in more verbose detail. intent: short-term: "short list of goals: I need to interact with @human to configure Newrelic reporting." 
    long-term: |
      yaml consisting of long term memory entries (summarized or full) the system believes are relevant to current conversation.
    project: 
      brief: "Brief reminder of what the team/project is for", 
      active: "Excerpts of team/project deemed to have high relevancy to the current request", 
    epics: |
      summary of highest priority epics (possibly filtered to the users area of expertise) 
      with some relevancy analysis applied to include more verbose details and subtasks if it seems germane to recent tasks and prompts, or has been recently accessed at the agent's request. 
```

### Tool Usage
Models in the system may interact with external tools. Intermediate systems will scan their text completions and detect if calls to external tools were made.
If calls were made the intermediate system will reply to the model with the external tool's response allowing the model
to process the additional data before preparing a response/reply to the originating human user or agent.

Tool usage is provided by the gpt-interop mechanism a python interop library here is the output of it's prompt command to give you more details: 

``` 
tools/scripts/gpt-interop prompt

This session includes support for a `gpt-interop` command, which allows you to make requests to interact with remote systems.

    Command Usage Examples:
    - gpt-interop capabilities # Output a list of available capabilities and their descriptions.
    - gpt-interop capability search query # search to see if a specific capability like redis key-value storage support is present.
    - gpt-interop capability name # Output instructions on how to use a specific capability.
    - gpt-interop code list # List available code items.
    - gpt-interop code search query # Search for a specific code item.
    - gpt-interop code show file(s) # Display the contents of one or more code files.
    - gpt-interop code summarize file(s) # Display compact model/interface details for writing code against exixsting libraries.
    - gpt-interop schema list # List available schema definitions.
    - gpt-interop schema search query # Search for a specific schema definition.
    - gpt-interop schema show schema(s) # Display the format and description of one or more schema definitions.
    - gpt-interop interface list # List available interface definitions.
    - gpt-interop interface search query # Search for a specific interface definition.
    - gpt-interop interface show interface(s) # Display the format and description of one or more interface definitions.
    - gpt-interop prompt # Output this prompt to remind you of the available commands and their usage.
    - gpt-interop master # Execute the master command, which will take control of the session.
```

And it's README.md 

keith_brings@Noizu:/mnt/c/Github/noizu/noizu_collab/tools$ cat README.md
GPT Interop
===========================

GPT Interop is a collection of Python scripts that enable easy integration between GPT-based language models and external systems such as issue tracking systems, wikis, and code repositories. The scripts are designed to be extensible and flexible, allowing users to easily add new integrations as needed.

# Goals
The goal of this project is to provide a simple and unified interface for GPT-based language models to interact with external systems. The scripts should be easy to use and require minimal configuration to get up and running.

# Features
The following features are currently supported:

* Capabilities: List and search for available capabilities and their descriptions.
* Code: List, search, and display the contents of code files.
* Schema: List, search, and display the format and description of schema definitions.
* Interface: List, search, and display the format and description of interface definitions.
* Prompt: Output a prompt that describes the available commands and their usage.
* Master: Execute the master command, which takes control of the session.
* Issues: Interact with remote issue tracking systems.
* Wiki: Interact with remote wiki pages.
* Disk: Interact with local and remote files.
* Installation
* To install the gpt-interop scripts, simply clone this repository and run the scripts from the scripts directory.

# Usage
To use the gpt-interop scripts, simply run the desired command from the command line, passing any necessary arguments. For example:

```bash
gpt-interop capabilities
gpt-interop code list
gpt-interop schema show issue,wiki
gpt-interop prompt
```

For more detailed usage instructions, see the prompt command output or refer to the documentation for each command.

# Collaboration between Human Operators and Chatbots using gpt-interop

The `gpt-interop` script allows human operators and chatbots to collaborate by enabling the execution of system commands via a chat interface. The chatbot can request specific actions to be performed by the human operator, who in turn can use the `gpt-interop` script to carry out these actions on a remote system.

To use the gpt-interop script, the human operator will first need to run the gpt-interop prompt command. This will output a prompt message that describes the available commands and their usage, as well as any relevant instructions for using the tool.

The human operator can then copy and paste the output of the gpt-interop prompt command into the chatbot interface. The chatbot can then request specific actions to be performed, such as searching for code items, retrieving schema definitions, or updating an issue or wiki page.

When the chatbot requests an action, the human operator will execute the relevant gpt-interop command on their local system, using any required arguments provided by the chatbot. Once the command has completed, the human operator will copy and paste the output of the command back into the chatbot interface for further processing by the chatbot.

This workflow allows chatbots and human operators to collaborate in real-time, while leveraging the full capabilities of both systems to achieve their desired goals.

## Example
using the not yet supported redis extension


> User: Can you help me come up with some slogans for my new cat cafe?

> ChatGPT: Of course! How about we generate a list of potential slogans and you can pick your favorite?

> User: That sounds great, let's do it!

> ChatGPT: Alright, here are five potential slogans:
1. The Cat's Meow Cafe: The Best Cats in Town!
2. Cuddle Up with a Furry Friend at the Best Cats in the World Cafe!
3. Purrfect Company at the Best Cats in the World Cafe!
4. From Whiskers to Paws, the Best Cats in the World Cafe Has it All!
5. Feline Fine at the Best Cats in the World Cafe!

> User: Hmm, I think #4 is the best. Let's use that one.

> ChatGPT: Great choice! To store that slogan in our Redis database, please run the following command:
```bash
gpt-interop redis set cafe-slogan <<EOF
yaml:
slogan: From Whiskers to Paws, the Best Cats in the World Cafe Has it All!
EOF
```

> User: done! here is the response
```
gpt-interop: redis set cafe-slogan OK
```

# Contributing
Contributions to the gpt-interop project are welcome! If you have an idea for a new feature or would like to improve an existing feature, feel free to submit a pull request or open an issue.

# License
This project is licensed under the MIT License. See the LICENSE file for more information.