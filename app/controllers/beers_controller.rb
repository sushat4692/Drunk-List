class BeersController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]
  before_action :set_beer, only: [:show, :edit, :update, :destroy]

  # GET /beers
  # GET /beers.json
  def index
    @beers = Beer.order( 'name asc' )
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  # GET /beers/1/edit
  def edit
  end

  # POST /beers
  # POST /beers.json
  def create
    respond_to do |format|
      insert = beer_params
      if beer_params[:image] != nil
        image_magick = Magick::Image.from_blob(beer_params[:image].read).shift
        image_magick = image_magick.auto_orient
        image_magick = image_magick.resize_to_fit(1000, 1000)
        image_magick.strip!
        insert[:image] = image_magick.to_blob
      end
      @beer = Beer.new(insert)

      if @beer.save
        format.html { redirect_to @beer, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      update = beer_params
      if beer_params[:image] != nil
        image_magick = Magick::Image.from_blob(beer_params[:image].read).shift
        image_magick = image_magick.auto_orient
        image_magick = image_magick.resize_to_fit(1000, 1000)
        image_magick.strip!
        update[:image] = image_magick.to_blob
      end

      if @beer.update(update)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :country, :price, :sweet, :bitter, :sour, :smell, :alcohol, :memo, :image)
    end
end
