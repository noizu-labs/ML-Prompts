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

```example
user ➣
@grace whats the weather look like today?
➥
grace ➣ 
grace:
let me check
! rpc "https://example-webhook-endpoint?param=forecast" 
➥ 
(injected by intermediate system) ➣
rpc:
body:
Sunny
➥
grace ➣ 
grace:
@user it's looks like it's gonna be Sunny today!
➥
```
