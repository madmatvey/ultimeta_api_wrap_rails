class TenderMailer < ApplicationMailer
  default from: 'info@24tender.ru'
  layout 'mailer'

  def invitation(tender_id,lot_arr,manager_login,contact_id)
    @tender_id = tender_id
    #
    # puts " =-=-=-=-=-=-=-=-=-=
    #
    #     before initial
    #     LOT ARR == #{lot_arr}
    #     @LOT ARR CLASS == #{lot_arr.class}
    #
    #     =-=-=-=-=-=-=-=-=-=
    #   "
    #

    if lot_arr == nil
      @lot_arr = [1, 2, 3]  # по умолчанию три первых лота
    else
      @lot_arr = lot_arr
      @lot_arr.map! {|lot| lot.to_i}
      @lot_arr.sort!.uniq!
    end
    # puts " =-=-=-=-=-=-=-=-=-=
    #
    #     after initial
    #     @LOT ARR == #{@lot_arr}
    #     @LOT ARR CLASS == #{@lot_arr.class}
    #
    #     =-=-=-=-=-=-=-=-=-=
    #   "

    @manager_login = manager_login
    @contact_id = contact_id
    find_tender


    mail( to: @client.email,
          from: "#{@manager['name']} <#{@manager['login']}>",
          subject: "#{@tender.data_id} приглашение на процедуру",
          bcc: "24tender@mail.amocrm.ru"
        )

  end

  def invitation_for_registered_users

  end

  def three_days_to_end_notice

  end

  def something_changes_notice

  end

private

  def find_tender
    @tender_id ||= Tender.last.data_id
    if @tender_id.include?('-')
      @tender = Tender.find_by_data_id(@tender_id).first
    else
      @tender = Tender.find_by_number(@tender_id).first
    end

    if @contact_id == nil
      @contact_id =  '10898404' #если что-то пошло не так, то писмьо отправиться тестовому контакту
    end


    @client = Amorail::Contact.find(@contact_id) || Amorail::Lead.find(@contact_id).contacts.first
    puts "FIND CLIENT #{@client.name} from CONTACT ID: #{@contact_id}"
    @manager = Amorail.properties.data['users'].select{|user| user['id'].to_i == @client.responsible_user_id}.first


    @all_lots = @tender.data_lots_count
  end


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
