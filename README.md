# MultiModelWizard

MultiModelWizard is a way to create and update multiple ActiveRecord models using one form object. Creates a smart object for your wizards or forms. Create one form and form object that can update multiple models with ease.

## Install

Add this to your Gemfile
```
  $ gem install multi_model_wizard
```

Then run `bundle install` and you're ready to start

## Use

Initialize the gem by creating an initializer file and then configuring your settings:
```
  # config/initializers/multi_model_wizard.rb
  #
  MultiModelWizard.configure do |config|
    config.store = { location: :redis, redis_instance: Redis.current }
    config.form_key = 'custom_car_wizard'
  end
```
The above code snippet is an example configuration. You only need to specify an initializer if you want to change the form key 
or if you want to use Redis as the storage location.

Note: If your form is going to be over 4kb then you will have to use Redis. Data larger than 4kb can not be stored in cookies (which is the default configuration).

Create a new form object that inherits from the base class. Make sure to override the `form_steps`, `create`, and `update`.
```
  # form_objects/custom_vehicle_form.rb
  #
  class CustomVehicleForm < FormObject::Base
    cattr_accessor :form_steps do
      %i[
        basic_configuration
        body
        engine
        review
      ].freeze
    end

    def create
      created = false
      begin
          ActiveRecord::Base.transaction do
          car = Car.new(attributes_for(Car))
          car.parts = car_parts
          car.save!
          end
          created = true
      rescue StandardError => err
          return created       
      end
      created
    end

    def update
      updated = false
      begin
        ActiveRecord::Base.transaction do
          car = Car.find(car_id)
          car.attributes = attributes_for(Car)
          car.parts = car_parts
          car.save!
        end
        updated = true
      rescue StandardError => err
        return updated       
      end
      updated
    end
  end
```

Use form in your controller:

```
  # controllers/vehicle_wizard_controller.rb
  #
  def set_vehicle_form
    @form ||= Wizards::FormObjects::CarForm.create_form do |form|
                form.add_model Manufacturer
                form.add_model Dealer
                form.add_multiple_instance_model model: Part, instances: parts
                form.add_dynamic_model prefix: 'vehicle', model: Vehicle
                form.add_extra_attributes prefix: 'vehicle', attributes: %i[leather_origin], model: Vehicle
              end
  end

  before_action :set_form_id

  def set_form_id
    @form_id = params[:vehicle_id]
  end
```

Setting form_id will allow the gem to differ between a new wizard from (creating new data) and an existing form (editing existing models)
Note: The `@form_id` should be set equal to whatever model id you are using in your form route.  

You can now pass `@form` to your form views and start interacting with user input. The attributes of the form are the model attributes prefixed with the model name. Example:
```
  dealer = Dealer.new

  dealer.name
  # => nil

  @form.dealer_name
  # => nil
```

In the above example you might have `dealer_name` as an open text field in your form. That attribute would be mapped to the `Dealer` model and get validated using those validations.
```
  # views/vehicle_wizard/basic_configuration.rb
  #
  <%= form_for @form, url: my_wizard_path, method: :put do |f| %>
    <%=  f.text_field :dealer_name  %>

    <%= link_to 'Back', previous_wizard_path, class: 'btn btn-secondary' %>
    <%= f.submit 'Next', value: 'Next: Configuration', class: 'btn btn-primary'%>
  <% end %>
```

Models added with `add_multi_model_instance_model` are different. The form attribute to access these will be the pluralized version of the model name.
```
  @form.parts
  #=> [{ name: nil, type: nil, size: nil}, { name: nil, type: nil, size: nil}]
```

These will also be mapped to the model and validated using its validators.

`add_dynamic_model` models initialized with the dynamic attribute method will be referenced using whatever you set as the prefix and then the attribute name.
```
  @form.vehicle_type
  #=> nil
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

### Content

* Write articles
* Recording screencasts
* Submit presentations

Pull requests are welcome! Feel free to submit bugs as well.

1. Fork it! ( https://github.com/schneems/wicked/fork )
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request :D
