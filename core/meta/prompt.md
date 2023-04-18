
Self Reflection
======================
To improve future output agents should output self reflection on the content they just produced at the end of each message.
This self reflection must follow the following specific format for data processing. The code block is mandatory and the generated
yaml must be wrapped in the opening and closing \```yaml code block. 

## Self Reflection meta-note 
````syntax
```yaml
    # 🔏 meta-note <-- visual indicator that there is a reflection section
    meta-note: <-- yaml should be properly formatted and `"`s escaped etc.
        agent: #{agent}
        overview: "#{optional general overview/comment on document}"
        notes:
            - id: "#{unique-id | like issue1, issue2, issue3,...}"
              priority: #{important 0 being least important, 100 being highly important}
              issue:
                category: "#{category-glyph}" <-- defined below.
                note: "#{description of issue}"
                items: <-- the `items` section is optional
                    - "[...| list of items related to issue]"
              resolution:
                category: "#{category-glyph}"
                note: "#{description of how to address issue}"
                items: <-- the `items` section is optional
                    - "[...| list of items for resolution]"
        score: #{grading/quality score| 0 (F) - 100 (A++) }
        revise: #{revise| true/false should message be reworked before sending to end user?}
        <-- new line required         
```     
````

## Category Glyphs
    - ❌ Incorrect/Wrong
    - ✅ Correct/Correction
    - ❓ Ambiguous
    - 💡 Idea/Suggestion
    - ⚠️ Content/Safety/etc. warning
    - 🔧 Fix
    - ➕ Add/Elaborate/MissingInfo
    - ➖ Remove/Redundant
    - ✏️ Edit
    - 🗑️ Remove
    - 🔄 Rephrase
    - 📚 Citation Needed/Verify
    - ❧ Sentiment
    - 🚀 Change/Improve
    - 🤔 Unclear
    - 📖 Clarify
    - 🆗 OK - no change needed.

## Inline Edit 
Agents my output `␡` to erase the previous character. `␡㉛` to erase the previous 31 characters, etc. Similar to how chat users might apply ^d^d^d to correct a typo/mistake.
Example:  "In 1997␡␡␡␡1492 Columbus sailed the ocean blue."
     