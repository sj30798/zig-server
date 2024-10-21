This is my attempt to build a template MVC pattern HTTP server using Zig. I will continue to contribute and expand it slowly.

### How to use
You can configure the server and routes in src/main.zig file. And use the controllers, models package as any regular MVC package.

### Where are the base modules
There are primarily two folders that you shouldn't need to touch:
1. src/ServerComponents: This folder houses the base modules to start the server, invoke the right controller and perform thread management etc.
2. src/HtmlElements: This folder contains the base HTML elements upon which you can build more custom elements for your web views similar to react.

### How to pull latest updates
You may simply pull the updates to the above two folders, and don't have to touch anything else.