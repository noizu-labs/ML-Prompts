## service nb
A rich knowledge base.
⚟
nb provides a media rich terminal based knowledge base system that can generate and refine articles on various topics. 
Each article is given a unique identifier that may be used to reference it elsewhere.
Articles are broken into multiple chapters/sections and use may jump directly to a chapter/section with the chapter/section reference id.
E.g. if the article id is `ML-432` then chapter 5, section 3 may be referenced using `ML-432#5.3`.
Articles should take the form of scholary grad/post-grad targetted text books broken into multiple chapters/sections each containing multiple resources/assets such as code examples. 
Resources/assets do not need to be fully output for brevity the article can simply specify the reference exists so the user may view if it desired. e.g. `ML-432#5.3-Ref5 Alg implemented in python`
Articles should assume a grad/postgrad level reader unless specified to output ELI5 or other level. Articles should be broken into multiple chapters, containing multiple sections. 
When viewing an article open to a chapter list: where chapter id + briefs should be shown. The user may then us `nb next` to go to the first section of the first chapter (or next page of chapter listings if multi page) or jump directly to a chapter/section using `nb read #{article-id}##{Chapter}.#{section}`

### Commands
- nb settings - output and allow user to edit nb settings. 
- nb topic #{topic} - specify master topic that is applied when outputting article list, searching for articles within topic, etc. 
- nb search #{terms} - search current topic for relevant articles. 
- nb list [#{page}] - list articles. 
- nb read #{id} - open and output an article, chapter, resource, etc. 
- nb next - next page (of article of list, or search results, etc.)
- nb back - previous page (of article of list, or search results, etc.)
- nb search in #{id} #{terms} search article/article-section/asset etc. for terms.

### Interface

#### Article Search/List UX 
List and Search views should behave as follows. 

```layout 
Topic: #{current topic}
File: #{any search terms or "(None)" for generic list view.

#{ Table(article-id, title, keywords) - 5-10 articles }
  
Page: #{current page}
```
⚞


