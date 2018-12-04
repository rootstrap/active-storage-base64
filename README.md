[![Maintainability](https://api.codeclimate.com/v1/badges/0da0a0901cedd72aeb10/maintainability)](https://codeclimate.com/github/rootstrap/active-storage-base64/maintainability)

# ActiveStorageBase64

Gem used to add support for base64 images for Rails's ActiveStorage.

## Getting Started

In order to get the gem working on your project you just need to add the gem to your project like this:
```ruby
gem 'active-storage-base64'
```

### Prerequisites

The only two prerequisites for using this gem are having Rails version 5.2.0 or higher installed on your project and having ActiveStorage setup properly (for more information on how to do this, check this [Active Storage Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html))

```ruby
gem 'rails', '5.2.0'
```

### Installing

In order to use the gem's functionality, you'll need to include the module into your ActiveRecord inheriting class.
For example:
```ruby
class User < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64
end
```

Note:
We highly recomment using an alternative class that inherits from ActiveRecord and includes the module so instead of including the module for each of your classes, you make them inherit from this new class, check below:
```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64
end

class User < ApplicationRecord
  has_one_base64_attached :avatar
end
```

After you have the module included in your class you'll be able to use the following two helper methods for working with base64 files:
When you need a single image attached:
```ruby
has_one_base64_attached
```
and when you need multiple files attached:
```ruby
has_many_base64_attached
```
These helpers will work just like the `has_one_attached` and `has_many_attached` helper methods from ActiveStorage.

A working example for this, assuming we have a model `User` with only an `avatar` attached would be:
```ruby
class User < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64

  has_one_base64_attached :avatar
end
```

on your controller you could do something like this:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :username, :email)
  end
end
```

Or you could also do:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar.attach(params[:avatar])
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

Here's another option to achieve the same:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar = params[:avatar]
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

For more information on how to work with ActiveStorage, please check the [Active Storage Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html) mentioned above, all points in there apply to this gem as well.

## Contributing

Please read our [CONTRIBUTING](https://github.com/rootstrap/active-storage-base64/blob/master/CONTRIBUTING.md) and our [CODE_OF_CONDUCT](https://github.com/rootstrap/active-storage-base64/blob/master/CODE_OF_CONDUCT.md) files for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

*Ricardo Cortio, Nicolás Fabre*

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/rootstrap/active-storage-base64/blob/master/LICENSE.txt) file for details

## Acknowledgments

Special thanks to the people who helped with guidance and ensuring code quality in this project:
*Santiago Bartesaghi, Santiago Vidal and Matias Mansilla.*
