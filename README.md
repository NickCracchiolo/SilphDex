# SilphDex
iOS and macOS app for Pokemon casual and VGC players to use to get Poked information, team build, and do damage calculations

Pokemon Data from the Pokeapi database (built off of Veekun database). Some information was missing and I added it in myself.
Core Data SQlite model too big for github. Will work on refiniing my localHost downloader and parser for the JSON -> CoreData.

Also includes a CoreML model made by me with about ~10,000 pictures of pokemon (front, back, female, shiny). 
The model was built using the new CreateML framework in macOS Mohave. Its accuracy is ok right now, howver the back images really mess it up.
I am playing around with the ml model and will integrate it with the iPhone's camera to make a real life point and shoot Pokedex.

