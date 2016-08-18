class TenderMailer < ApplicationMailer
  default from: 'info@24tender.ru'

  def invitation(tender = nil, lot_arr, manager_pic)
    @tender = tender
    if @tender == nil
        @tender = tender_not_find
    end
    # @url  = 'http://example.com/login'
    @lot_arr = lot_arr
    @manager_pic = manager_pic
    mail(to: "e_leontiev@24tender.ru", subject: "#{@tender.data_id} приглашение на процедуру")
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
      'lots' =>
        {
          'lot' =>
          {
            'customer' => "404, NOT FOUND",
            'goods' =>
              {
                'Characteristic' => "404, NOT FOUND",
                'Price' => nil,
                'Currency' => 'RUB'
              }
          }
        },
      'PurchaseStart' => "1904-01-01T00:00:00.000+00:00",
      'PurchaseFinishDate' => "1904-01-01T00:00:00.000+00:00"

      }})
  end
end
