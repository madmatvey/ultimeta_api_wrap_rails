class AmowidgetController < ApplicationController
  after_action :allow_amo_iframe
  layout 'widget'
  # GET /amowidget
  # GET /amowidget.json
  def index
    @tenders = Tender.all
    @tenders_active_now = Tender.all_active_now
    @tenders_unfinished = Tender.all_unfinished
    @import_last = Import.last
    json_msg = {
                  tenders: Tender.data_ids,
                  tenders_active_now: Tender.data_ids(@tenders_active_now),
                  tenders_unfinished: Tender.data_ids(@tenders_unfinished),
                  import_last: @import_last.time_to
               }
    respond_to do |format|
      format.html
      format.json  { render :json => json_msg }
    end

  end


  private
    def amowidget_params
      params.fetch(:amowidget, {})
    end

    def allow_amo_iframe
      response.headers.except! 'X-Frame-Options'
      response.headers['X-XSS-Protection'] = "0"
    end
end
