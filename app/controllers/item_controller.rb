class ItemController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @items = @user.items.all.order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
    @group_items = @item.groups
    @groups = Group.where.not(id: @item.groups.pluck(:id))
  end

  def new
    @item = Item.new
    @groups = current_user.groups
  end

  def create
    @group = Group.find(item_params[:group_id])
    @item = current_user.items.new(item_params.except(:group_id))

    respond_to do |format|
      if @item.save
        @item.add_unique_group(@group)
        format.html { redirect_to item_path(@item), notice: 'Item was successfully created.' }
      else
        format.html { render :new, staus: :unprocessable_entity, alert: 'Something went wrong' }
      end
    end
  end

  def add_group
    @item = Item.find(params[:id])
    @group = Group.find(params[:format])
    @item.add_unique_group(@group)
    redirect_to item_path(@item)
  end

  private

  def item_params
    params.require(:item).permit(:name, :amount, :author_id, :group_id)
  end
end