# Beer hookup

This application uses the PUNK API to search beers and show info about them.
It requires Ruby version 3.1.

## Installation
Clone the repository and install dependencies using the following commands
```sh
 $ git clone git@github.com:sammyhenningsson/beer_hookup.git
 $ cd beer_hookup
 $ bundle install
 $ npm install --global yarn
 $ yarn build
 $ yarn build:css
```

It caches the beer data in a sqlite3 database. So we need to run a migration to setup the database.
```sh
 $ rails db:migrate
```

## Starting the application
The application is started using
```sh
 $ rails server
```


## Testing
To verify that everything works as intended run the test suite with:
```sh
 $ rspec
```
