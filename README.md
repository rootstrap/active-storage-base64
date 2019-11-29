[![Build Status](https://travis-ci.org/rootstrap/active-storage-base64.svg?branch=master)](https://travis-ci.org/rootstrap/active-storage-base64)
[![Maintainability](https://api.codeclimate.com/v1/badges/0da0a0901cedd72aeb10/maintainability)](https://codeclimate.com/github/rootstrap/active-storage-base64/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0da0a0901cedd72aeb10/test_coverage)](https://codeclimate.com/github/rootstrap/active-storage-base64/test_coverage)

# ActiveStorageBase64

Adds support for base64 attachments to ActiveStorage.

## Installation

In order to get the gem working on your project you just need to add the gem to your project like this:
```ruby
gem 'active_storage_base64'
```

## Prerequisites

The only prerequisites for using this gem are having Rails version 5.2.0 or higher installed on your project and having ActiveStorage properly set up (for more information on how to do this, check [Active Storage Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html))

## Usage

In order to use the gem's functionality, you need to include the `ActiveStorageSupport::SupportForBase64` module in your ActiveRecord models.
For example:
```ruby
class User < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64
end
```

Note:
We highly recommend using an alternative class that inherits from `ActiveRecord::Base` and includes the module so instead of including the module for each of your classes, you make them inherit from this new class, check below:
```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64
end

class User < ApplicationRecord
  has_one_base64_attached :avatar
end
```

After you have the module included in your class you'll be able to use the following two helper methods to work with base64 files:
When you need a single image attached:
```ruby
has_one_base64_attached
```
and when you need multiple files attached:
```ruby
has_many_base64_attached
```
These helpers will work just like the `has_one_attached` and `has_many_attached` helper methods from ActiveStorage.

A working example for this, assuming we have a model `User` with an `avatar` attached would be:
```ruby
class User < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64

  has_one_base64_attached :avatar
end
```

on your controller you could do any of the following:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(avatar: :data, :username, :email)
  end
end
```

```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar.attach(data: params[:avatar]) # params[:avatar] => 'data:image/png;base64,[base64 data]'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar.attach(avatar_params) # avatar_params => { data: 'data:image/png;base64,[base64 data]' }
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end

  def avatar_params
    params.require(:avatar).permit(:data)
  end
end
```

```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar = { data: params[:avatar] } # params[:avatar] => 'data:image/png;base64,[base64 data]'
    user.save
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

### Specifying a filename or content type

If you are willing to add a specific filename to your attachment, or send in a specific content type for your file, you can use `data:` to attach the base64 data and specify your `filename:`, `content_type:` and/or `identify:` hash keys.
Check the following example:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    user.avatar.attach(data: params[:avatar], filename: 'your_filename', content_type: 'content/type', identify: 'false') # params[:avatar] => 'data:image/png;base64,[base64 data]'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

Or, in case you want to have the avatar attached as soon as the user is created you can do:
```ruby
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, avatar: [:data,
                                                             :filename,
                                                             :content_type,
                                                             :identify])
  end
end
```

### Data Format

To attach base64 data it is required to come in the form of [Data URIs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs) .
For example:
```
data:image/png;base64,[base64 data]
```

## Contributing

Please read our [CONTRIBUTING](https://github.com/rootstrap/active-storage-base64/blob/master/CONTRIBUTING.md) and our [CODE_OF_CONDUCT](https://github.com/rootstrap/active-storage-base64/blob/master/CODE_OF_CONDUCT.md) files for details on our code of conduct, and the process for submitting pull requests to us.

## Author

*Ricardo Cortio*

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/rootstrap/active-storage-base64/blob/master/LICENSE.txt) file for details

## Acknowledgments

Special thanks to the people who helped with guidance and ensuring code quality in this project:
*Santiago Bartesaghi, Santiago Vidal and Matias Mansilla.*

## Credits

Active Storage Base64 is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our
[contributors](https://github.com/rootstrap/active-storage-base64/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
