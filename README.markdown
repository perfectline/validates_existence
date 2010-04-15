# ValidatesExistence

This plugin library adds ActiveRecord models a way to check if a `:belongs_to` association actually exists upon saving.  
This is achieved via adding a `validates_existence_of` validator to the base validations module.  
It also supports `:allow_nil => true/false` and `:polymorphic => true` associations.

Version 0.4.0 also adds Rails 3 support  (the appropriate version is used automatically).

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

      validates_existence_of :person, :allow_nil => true
    end

    pony = Pony.new
    pony.wizard_id = 100 # such wizard does not exist ofcourse
    pony.valid?

    pony.errors.on(:wizard) #=> "does not exist"

#### Rails 3

In addition to the "old" functionality, Rails 3 version introduces a new option `:both => true`.
This adds the error message on both `relation` and `relation_id` fields for convenience.

    class Unicorn < ActiveRecord::Base
      belongs_to :wizard
      belongs_to :person, :polymorphic => true

      validates :wizard,    :existence => true
      validates :wizard_id, :existence => true # works both way
      validates :person,    :existence => { :allow_nil => true, :both => true }

      # the old method is supported also
      validates_existence :wizard
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