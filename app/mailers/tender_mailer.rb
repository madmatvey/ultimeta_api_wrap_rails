class TenderMailer < ApplicationMailer
  default from: 'no-reply@24tender.ru'

  def invitation(tender = nil)
    @tender = tender
    if @tender == nil
        @tender = tender_not_find
    end
    @url  = 'http://example.com/login'
    mail(to: "e_leontiev@24tender.ru", subject: 'Test Invites to Tenders')
  end

  def invitation_for_registered_users

  end

  def three_days_to_end_notice

  end

  def something_changes_notice

  end

private

  def tender_not_find
    Tender.new({data:{
      'Link' => 'http://24tender.ru',
      'Id' => "404, NOT FOUND",
      'lots' => {
          'lot' => {
              'customer' => "404, NOT FOUND"
            }
        }
      }})
  end
end
