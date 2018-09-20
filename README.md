# SilphDex
iOS and macOS app for Pokemon casual and VGC players to use to get Poked information, team build, and do damage calculations

Pokemon Data from the Pokeapi database (built off of Veekun database). Some information was missing and I added it in myself.
Core Data SQlite model too big for github. Will work on refiniing my localHost downloader and parser for the JSON -> CoreData.

### Pokemon Image Recognition
Machine Learning model built using CreateML and macOS Mohave. 
* 25 Iterations
* 93,507 images
* All 807 Pokemon species, most megas and some alolan forms (Used the images I could get, Converted some PKParaiso gifs frames to pngs to increase image count)
* Run time: 7.9 hours on 4 core 2016 i7 MBP
* Model Accuracy: 88% Training, 86% Validation

*This app uses data, images, and terminology from the Pokemon Franchise. This is all intellectual property of Nintendo, TPCI, and Gamefreak and is protected by various trademarks and copywrite laws. The author of this application believes that the use of this intellectual property is covered under fair use and the software is significantly impared without said intellectual property.*
