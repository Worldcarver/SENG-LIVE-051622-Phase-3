class DogWalksController < ApplicationController
  
  # ✅ we want to be able to create dog_walks through the API

  post "/dog_walks" do 
    dog_walk = DogWalk.create(dog_walk_params)
    # dog_walk = DogWalk.create(params)
    # dog_walk = DogWalk.create(dog_id: params[:dog_id], time: params[:time])
    dog_walk.to_json
  end
  

  # ✅ we want to be able to update dog_walks through the API

  patch "/dog_walks/:id" do 
    dog_walk = DogWalk.find(params[:id])
    dog_walk.update(dog_walk_params)
    dog_walk.to_json
  end
 
 

  # ✅ we want to be able to delete dog_walks through the API

  delete "/dog_walks/:id" do 
    dog_walk = DogWalk.find(params[:id])
    dog_walk.destroy
  end
  
  
  

  private 

  # a method used to specify which keys are allowed through params into the controller
  # we use this method to create a list of what's permitted to be passed to .create or .update
  # within controller actions.
  def dog_walk_params
    # allowed_params = %w(dog_id walk_id pooped)
    # params.select {|param,value| allowed_params.include?(param)}

    params.permit(:dog_id, :walk_id, :pooped)
  end

  def get_dog_walk_json_config()
    {
      methods: [:formatted_time]
    }
  end
end