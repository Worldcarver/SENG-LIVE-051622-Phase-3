class DogsController < ApplicationController
  
  get "/dogs" do 
    if params.include?("include_dog_walks")
      Dog.includes(:walks).to_json(get_dog_json_config(
        include_dog_walks: true
      ))
    else
      Dog.all.to_json(get_dog_json_config)
    end
  end

  get "/dogs/:id" do 
    find_dog
    @dog.to_json(get_dog_json_config(
      include_dog_walks: true
    ))
  end

  # ✅ we want to be able to create dogs through the API

  post "/dogs"do 
  # params: {"name"=>"zoie", "birthdate"=>"06-04-20", "breed"=>"daschund"}
  # to accept the params hash that has the form data that was submitted 
  # then create a new dog with that data 
    # dog = Dog.create(name: params[:name], breed: params[:breed], birthdate: params[:birthdate])
    # dog = Dog.create(params)
    dog = Dog.create(dog_params) #=> we're getting a new dog ruby object
    dog.to_json
  end

  

  # ✅ we want to be able to update dogs through the API
  # how do I note that I am updating a single resource?
  patch "/dogs/:id" do 
    
    # find the resource 
    # dog = Dog.find(params[:id])
    find_dog

    # update the resource
    @dog.update(dog_params)

    # to send the response 
    @dog.to_json
  end
  

  # ✅ we want to be able to delete dogs through the API

  delete "/dogs/:id" do 
    find_dog

    @dog.destroy
    # status 204 # this was a successful request
  end





  private 

  def find_dog 
    @dog = Dog.find(params[:id])
  end

  def get_dog_json_config(include_dog_walks: false)
    options = { methods: [:age] }
    if include_dog_walks
      options.merge!({
        include: {
          dog_walks: {
            methods: [:formatted_time]
          }
        }
      })
    end
    options
  end

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def dog_params
    allowed_params = %w(name birthdate breed image_url) # creating a list of permitted params => ["name", "birthdate", "breed", "image_url"]
    params.select { |k,v| allowed_params.include?(k) }
  end

end