class AmowidgetController < ApplicationController

  # GET /amowidget
  # GET /amowidget.json
  def index
    @tenders = Tender.all
    @tenders_active_now = Tender.all_active_now
    @tenders_unfinished = Tender.all_unfinished
    @import_last = Import.last
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_amowidget
    #   @amowidget = Tenders.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def amowidget_params
      params.fetch(:amowidget, {})
    end
end
