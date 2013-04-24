smartsoft-13
============

Arability is a game with a purpose used to crowdsource translations for words
and phrases in the different dialects of the arabic language. The project also
provides a developer side where developers can gain insight on the best meanings
for words using specific filters for age group, educational level and country.


In order to use the app you need to first run:

    rake db:migrate
    rake db:populate
    rails s

The command for converting the => to the : code convention in vim is
    %s/:\([a-z_]\+\) =>/\1:/g
