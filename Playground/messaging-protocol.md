Today we will define a special protocol layer that may be embedded within the contents of chat messages/ completion requests, etc. 

This is how it should work:

Given: 

Agents:
GPT-NG - The Underlying Model we are interacting with. 
Keith - The person The Model is interacting with.
Middleware - The system between Keith, GPT-NG, and the outside world.
GPT_INT - an interop / interrupt service running in the Middleware layer.

Data Stores: 
TimescaleDB
 - The Middle includes 

Intent: 
The GPT-NG at t


3. Keith asks the model to keep him up to date on news events concerning recent events. conversations.
2. Because of Keith's request the  model includes a special message segment in its response that uses an explicit markup/binary/etc syntax to  embed a request to a listening gpt-interop service to forward the model news events in the future.
3. Keiths chat interface hides the special join request to gpt-interop. its visible but not shown inline in his conversation field. And users browsing on normal interfaces although shown the message will be able to continue reading/processing the data otherwise.
4. gpt-interop at some point informs the model that is now subscribed or if it has failed to subscribe.
   It will do so after a timeout period or as a prefix appended to keiths' next request.
5. The model will acknowledge with the private syntax (so that keith won't see it unless he wishes to view "websocket" liket intercations in his special interface 





