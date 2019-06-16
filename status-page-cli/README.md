# README

## How to run 

Make sure you have Ruby, Sqlite and Bundler installed then do
```
chmod +x main.rb
./main.rb pull
```

## Commands

### pull

```
./main.rb pull 
```
Pulls data from all accessible services one time, prints the output to the screen and writes to db
```
./main.rb pull --nodisplay
```
Turns off screen output
```
./main.rb pull --nosave
```
Does not affect db state
```
./main.rb pull --except github bitbucket
```
Excludes listed providers from the query
```
./main.rb pull --only github bitbucket
```
Leaves only listed providers in the query
### live
```
./main.rb live
```
Pulls data from all accessible services indefinetely, prints the output to the screen and writes to db
```
./main.rb live --nodisplay
```
Turns off screen output
```
./main.rb live --nosave
```
Does not affect db state
```
./main.rb live --except github bitbucket
```
Excludes listed providers from the query
```
./main.rb live --only github bitbucket
```
Leaves only listed providers in the query
```
./main.rb live --refresh 20
```
Sets waiting time before next set of queries in seconds

### history
```
./main.rb history --status up --service Github
```
Show history records, filtered by status and service. Filters may be ommited
### backup
```
./main.rb backup file.sqlite
```
Copies the content of the db to the file at the set path, no additional parameters accepted
### restore
```
./main.rb restore file.sqlite
```
Copies the content of the previously copied db into current db

```
./main.rb restore file.sqlite --drop
```
Drops current db then copies the content of the previously copied db into current db


