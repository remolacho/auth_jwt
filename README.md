# AuthJwt

This gem allows you to make identifications for your microservices and create the Jwt if you wish so

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auth_jwt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install auth_jwt

## Usage

  Once installed run the following commands:
  
   1- It will create a file in the initializer so you can configure the parameters

     rails g auth_jwt:install
   
   2- Create a helper in the spec support to handle authentication tests
     
     rails g auth_jwt:test_helper

   3- In your main controller or base you must add the module
   
     include AuthJwt
     
     Example
     class ApiController < ActionController::API
       include AuthJwt
     end

   4- You can use two methods for accessing your API
   
     before_action :authorized_app
     before_action :authorized_user
    
     Example
     class ApiController < ActionController::API
       include AuthJwt
       
       before_action :authorized_app # Authenticate the client app
       before_action :authorized_user # Identify the user based on the jwt for login
     end
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/auth_jwt.

