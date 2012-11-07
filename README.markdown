# ValidatesExistence

This plugin library adds ActiveRecord models a way to check if a `:belongs_to` association actually exists upon saving.  
This is achieved via adding a `validates_existence_of` validator to the base validations module.  
It also supports `:allow_nil => true/false`, `:allow_new => true/false`, and `:polymorphic => true` associations.

Version 0.4.0 also adds Rails 3 support  (the appropriate version is used automatically).
Version 0.5.0 introduces a new option - `:both` and changes the default behaviour of error attaching.

#### Changes in 0.5.3

Cleaned up the code, the whole library is now in one file with separate modules for Rails 2 and Rails 3.
Also renamed `should_macros` folder to `shoulda`.

#### Changes in 0.5.0

In verions prior to 0.5.0 the error message was attached to the field which the validation was defined on.
For example if the validation was on `:relation_id` field, then the error was accessible via `object.errors.on(:relation_id)`.
The new default behaviour is attaching the error on both fields: `:relation` and `:relation_id` for convenience.
This functionality can be controlled through the `:both` option, which accepts true/false value and defaults to true.

#### TODO

+ replace T::U tests with RSpec
+ create RSpec Matcher
+ separate set of tests for Rails 3

### Installation
First install the gem:
    sudo gem install validates_existence

#### Rails 2.x
    # environment.rb
    config.gem "validates_existence", :source => "http://rubygems.org"

#### Rails 3
    # Gemfile
    gem "validates_existence", ">= 0.4"

### Example usage

#### Rails 2.x
    class Pony < ActiveRecord::Base
      belongs_to :wizard
      belongs_to :person, :polymorphic => true

      validates_existence_of :wizard_id
      validates_existence_of :wizard      #works both ways

      validates_existence_of :wizard, :both => false

      validates_existence_of :person, :allow_nil => true
    end

    pony = Pony.new
    pony.wizard_id = 100 # such wizard does not exist ofcourse
    pony.valid?

    pony.errors.on(:wizard) #=> "does not exist"

#### Rails 3
    class Unicorn < ActiveRecord::Base
      belongs_to :wizard
      belongs_to :person, :polymorphic => true

      validates :wizard,    :existence => true
      validates :wizard_id, :existence => true # works both way
      validates :person,    :existence => { :allow_nil => true, :both => false }

      # the old method is supported also
      validates_existence_of :wizard
    end
    
## I18N

The default error message is `does not exist`.  
This can be customized via Rails I18N like any other validation error message via `:existence` key.

### Example

This would be your customized en.yaml:

    en:
      activerecord:
        errors:
          messages:
            existence: "has gone missing!"

## Honorable mentions
This plugin is inspired by ideas from **Josh Susser**

## Authors
**Tanel Suurhans** - tanel.suurhans_at_perfectline_d0t_ee  
**Tarmo Lehtpuu** - tarmo.lehtpuu_at_perfectline_d0t_ee

## License
Copyright 2010 by PerfectLine LLC (<http://www.perfectline.co.uk>) and is released under the MIT license.
