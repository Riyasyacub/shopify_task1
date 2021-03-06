class EntitiesController < ApplicationController
  def new
    @entity = Entity.new
    @drop = params[:format]
    @tiers = Tier.all.pluck(:name)
  end

  def create
    @entity = Entity.new(name: entity_params[:name], msrp: entity_params[:msrp], drop_id: entity_params[:drop_id])
    @box = Drop.where(id: entity_params[:drop_id]).first.box
    @tier = Tier.all
    # @entity.price = {} 
    @tier.each_with_index do |t,i|
      @en = Connection.new(price: entity_params['price'][i],tier_id: t,entity_id: @entity)
      if @en.save
        
      else
        raise @en.errors.inspect
      end
    end
    if @entity.save
      
      redirect_to box_path(@box)
    else
      raise @entity.errors.inspect
    end
  end

  private

  def entity_params
    params.require(:entity).permit(:name,:msrp,:drop_id, :price => [])
  end

end
