class TenderMailer < ApplicationMailer
  default from: 'no-reply@24tender.ru'

  def invitation(tender = nil)
    @tender = tender
    @url  = 'http://example.com/login'
    mail(to: "e_leontiev@24tender.ru", subject: 'Test Invites to Tenders')
  end

  def invitation_for_registered_users

  end

  def three_days_to_end_notice

  end

  def something_changes_notice

  end
end
