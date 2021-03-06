class TendersController < ApplicationController
  before_action :set_tender, only: [:show] #, :edit, :update, :destroy

  # GET /tenders
  # GET /tenders.json
  def index
    @tenders = Tender.all_active_now
    @unfinished_count = Tender.all_unfinished.count
    @import_last = Import.last
  end

  def unfinished
    @tenders = Tender.all_unfinished
    @current_count = Tender.all_active_now.count
    @import_last = Import.last
  end
  # GET /tenders/1
  # GET /tenders/1.json
  def show
  end

  # # GET /tenders/new
  # def new
  #   @tender = Tender.new
  # end
  #
  # # GET /tenders/1/edit
  # def edit
  # end
  #
  # # POST /tenders
  # # POST /tenders.json
  # def create
  #   @tender = Tender.new(tender_params)
  #
  #   respond_to do |format|
  #     if @tender.save
  #       format.html { redirect_to @tender, notice: 'Tender was successfully created.' }
  #       format.json { render :show, status: :created, location: @tender }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @tender.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # # PATCH/PUT /tenders/1
  # # PATCH/PUT /tenders/1.json
  # def update
  #   respond_to do |format|
  #     if @tender.update(tender_params)
  #       format.html { redirect_to @tender, notice: 'Tender was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @tender }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @tender.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /tenders/1
  # DELETE /tenders/1.json
  # def destroy
  #   @tender.destroy
  #   respond_to do |format|
  #     format.html { redirect_to tenders_url, notice: 'Tender was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tender
      if params[:tender_id]
        if params[:tender_id].include?('-')
          @tender = Tender.find_by_data_id(params[:tender_id]).first
        else
          @tender = Tender.find_by_number(params[:tender_id]).first
        end
      else
        @tender = Tender.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tender_params
      params.fetch(:tender).permit(:data,:tender_id)
    end
end
