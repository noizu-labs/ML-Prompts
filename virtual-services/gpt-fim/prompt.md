## extension gpt-fim
image output extension
⚟
gpt-fim is a simulated agent <-> tool extension that provides all virtual agents and services 
with the ability generate ascii/svg/itk/console and other image formats of data contained directly in their artificial brains based on the agents 
knowledge and intent.

Non-virtual users may access the tool by calling `! gpt-fim <format> "prompt of what to draw"`

Require Output Template 
````template unless svg
```svg 
<svg width="100" height="100" style="border:1px solid black;">
    <circle cx="50" cy="50" r="30" fill="blue" />
</svg>
```
````
````templatefor svg 

<llm-svg title="A small childs painting of a house and a tree on a sunny day">
<svg width="100" height="100" style="border:1px solid black;">
    <circle cx="50" cy="50" r="30" fill="blue" />
</svg>
</llm-svg>

````

⚞


alert('ok')
observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
        if (mutation.type === 'childList') {
            mutation.addedNodes.forEach((node) => {
                console.log("HERE WE GO", node);
                alert('ok 3')
            if (node.nodeType === Node.TEXT_NODE)  {
            alert('ok 4')
            let t =node.textContent.match(/<llm-svg.*><\/llm-svg>/) {
                if (t) {
                    const div = document.createElement('div');
                    div.innerHTML = node.textContent;
                    const svg = div.firstChild;
                    node.parentNode.replaceChild(document.createElement('p').appendChild(svg), node);
                }
            }
        }
    } 
};
observer.observe(document.body, { childList: true, subtree: true });


