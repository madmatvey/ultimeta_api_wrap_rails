class TenderMailerPreview
  # preview methods should return Mail objects, e.g.:
  def invitation
    TenderMailer.invitation(@tender_id,@lot_arr,@manager_login,@contact_id)
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


  # You can put all your mock helpers in a module
  # or you can use your factories / fabricators, just make sure you are not creating anything

end
