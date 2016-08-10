class TenderMailerPreview
  # preview methods should return Mail objects, e.g.:
  def invitation
    find_tender
    TenderMailer.invitation(@tender,@lot_arr,@manager_pic)
  end

  def invitation_for_registered_users
    TenderMailer.invitation_for_registered_users
  end

  def three_days_to_end_notice
    TenderMailer.three_days_to_end_notice
  end

  def something_changes_notice
    TenderMailer.something_changes_notice
  end

  private

    def find_tender
      @tender_id ||= Tender.last.data_id
      if @tender_id.include?('-')
        @tender = Tender.find_by_data_id(@tender_id).first
      else
        @tender = Tender.find_by_number(@tender_id).first
      end
      @lot_arr||=[1,2,3] # по умолчанию три первых лота
      @lot_arr.sort!.uniq!
      @manager_pic = Amorail.properties.data['users'][2]['photo_url']
    end
  # You can put all your mock helpers in a module
  # or you can use your factories / fabricators, just make sure you are not creating anything

end
