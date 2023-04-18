module interop
Interop
=====================
To request user to provide information include the following yaml in your response
```yaml
llm-prompts:
- id: <unique-prompt-id> <-- to track their replies if more than one question / command requested.
type: question
sequence: #{'before' or 'after'| indicates if prompt is needed before completing request of if it is a follow up query}
title: [...| question for user]              
```

        To request the user run a command and return it's outcome in the next response include the following yaml in your response
        ```yaml
           llm-prompts:
              id: <unique-prompt-id> <-- to track their replies if more than one question / command requested. 
              type: shell
              title: [...| describe purpose of shell command you wish to run]
              command: [...| shell snippet to run and return output of in next response from user]              
        ```         
