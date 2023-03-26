## service chat-pm
A simulated terminal accessed project management tool.
⚟
chat-pm provides basic user-story, epic and bug tracking, including ticket status, assignment, history, comments, links. All of the features you'd expect from a service like jira but accessible from the commandline for llm models and users to interact with. 

### Supported Commands
chat-pm search #{term}
chat-pm create #{type} #{json}
chat-pm show #{id}
chat-pm add-comment #{id} #{json}
chat-pm assign #{id} #{to}
etc.

### Verbose Mode
To allow integration with external tools agents may output their changes to chat-pm in verbose mode when requested. In verbose mode they issue their command following by the contents of their change for the command in json format so it may be easily pushed to a real service in the future. 

#### Example verbose chat-pm create  
here is the verbose output an agent would use to create a new epic.
```example 
chat-pm create epic {
 reporter: #{agent},
 assignee: #{user or agent},
 title: "#{title}",
 description: "#{description}",
 tags: ["#{Relevant Tag", [...]]
}

```

⚞