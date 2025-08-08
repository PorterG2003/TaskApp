class ComponentsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'components'
  
  def index
    # This will be our component showcase/preview page
  end
end
