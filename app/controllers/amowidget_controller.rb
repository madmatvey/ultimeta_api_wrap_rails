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


  def send_mail_invitation
    if params[:amowidget]['lot_arr'] != nil
      @lot_arr = params[:amowidget]['lot_arr']
      if @lot_arr.size == 1
        @lot_arr = @lot_arr[0].split(" ")
      end
    else
      @lot_arr = [1,2,3]
    end
    puts "
          PARAMS: #{params}
          params[:tender] = #{params[:amowidget]['tender']}
          @lot_arr = #{@lot_arr}
          params[:manager] = #{params[:amowidget]['manager']}
          params[:client] = #{params[:amowidget]['client']}
          "
    job = TenderMailer.invitation(params[:amowidget]['tender'],@lot_arr,params[:amowidget]['manager'],params[:amowidget]['client']).deliver_now
    render json: job
    # mail = ActionMailer::MessageDelivery.new
    # ActionMailer::MessageDelivery.new() #_json(params[:mail]).deliver_now
    # job = MailSendJob.perform_later(params[:mail])
    #
  end


  private
    def amowidget_params
      # params.fetch(:amowidget, {})
      params.require(:amowidget).permit(:tender,:manager,:client,:lot_arr => [])
    end

end
