class AmowidgetController < ApplicationController
  after_action :allow_amo_iframe
  # GET /amowidget
  # GET /amowidget.json
  def index
    @tenders = Tender.all
    @tenders_active_now = Tender.all_active_now
    @tenders_unfinished = Tender.all_unfinished
    @import_last = Import.last
  end


  private
    def amowidget_params
      params.fetch(:amowidget, {})
    end

    def allow_amo_iframe
      response.headers.except! 'X-Frame-Options'
    end
end
