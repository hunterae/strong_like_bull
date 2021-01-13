# StrongLikeBull

Makes it super simple to add strong parameters into your application by examining request parameters and recommending what feeds should be permitted.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strong_like_bull'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strong_like_bull

## Usage

In application_controller.rb or a specific controller, add the following line:

    include StrongLikeBull

In any controller action where you want a recommendation for the strong parameters permitted parameters based on the request parameters, add the following inside the action:

    def CONTROLLER_ACTION
      log_suggested_strong_parameters_format(PARAMETER_NAME_TO_INSPECT)
      # perform action
    end

When the controller action gets hit, it will log the recommended strong params permitted params to use in the following format:

    STRONG PARAMETERS: #{self.class}##{action_name} - suggested format: RECOMMENDED_PERMITTED_PARAMS

If we don't want this to be logged, we could utilize the method "suggested_strong_parameters_format", which will return the object representation of the strong parameters format. Like "log_suggested_strong_parameters_format", it also takes the PARAMETER_NAME_TO_INSPECT as a parameter.

## Caution
StrongLikeBull only serves to recommend params to permit based on what is passed in to the request. It cannot make guesses about the security of your application, or which parameters should be restricted. With this in mind, it is recommended to carefully examine the results to determine if some permitted params should be removed from the recommendation before permitting your params.

## Example

If you wanted the recommended params to permit for the update action of a Posts Controller, it would like:

    def update
      log_suggested_strong_parameters_format(:post)
      # perform update
    end

The above example would assume the a a parameter is passed to the controller called "post" which contained all the fields we want to permit. The request parameters might look something like this:

    { post: { name: "My Post", tags: ["Personal", "Life"], description: "A description about my post" }}

If those request parameters were passed to the update action above, we'd see the following as a result in our logs:

    STRONG PARAMETERS: PostsController#update - suggested format: params.require(:post).permit [:name, {:tags=>[]}, :description]

Using that suggested format, we could then modify our update action to the following:

    def update
      permitted_params = params.require(:post).permit [:name, {:tags=>[]}, :description]
      # perform update
    end
