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

## Config

The tool has to be configured by editing `config/config.yml`

### DB mode
Tool can utilize SQL or JSON for its backend. Use `sql` to toggle these modes.
```yaml
sql: false
```

### Services
```yaml
services:
  bitbucket:
    name: 'BitBucket'
    implementation: 'bitbucket'
    options:
      host: ['bitbucket.org', 'id.atlassian.com']
      policy: 'all'
  anotherserver:
    name: 'foo'
    implementation: 'bar'
```
Primary setting to be set is `services` structure.
* `name` is obligatory
* `implementation` is optional. See _custom services_.
* `options` is a structure that contains options for a particular service implementation. May or may not be obligatory.
* if no `implementation` is set then `options` must contain array or string of `host`. `policy` is optional in this case. Setting `policy` to `all` will require each host to be active, when by default a single host is enough for the positive test

## Custom services

This tool supports custom polling implementations.

Say you have your own service that requires very special testing routine like SSHing it or something.

Here are the steps to create your own implementation:

### Step 1. Define implementation class

Create file `services/my_service.rb`. Be attentive about naming.
```ruby
require_relative 'application_service'
class MyService < ApplicationService
  def pull
    # in real life here must be more sensible calculation
    # @service is settings structure that is forwarded from config
    # if @silent is true, make sure you make no output to console
    {
      name: 'MyService',
      status: ['up', 'down'].sample,
      date: Time.now
    }
  end
end
```
IMPORTANT! make sure `pull` method returns hash as shown above

### Step 2. Set config
After class is created, make sure you have configured it `config/config.yml`
```yaml
services:
  myserver:
    name: 'foo'
    implementation: 'my'
    options:
      option1: 'bar'
```
Conventions:
* For the sake of uniformity put your options into `options` key.
* `implementation` field is important, so the tool can find your class.
* In this example it is `MyService` class in `services/my_service.rb` file.
* `default` is not to be used as an implementation name
* `implementation` must be *snake_case*
