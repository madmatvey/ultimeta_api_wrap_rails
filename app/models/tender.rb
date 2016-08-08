class Tender < ActiveRecord::Base
  has_many :modifications

  def data_id
    self.data['Id']
  end

  def data_link
    url = URI.parse(self.data['Link'])
    url.host = url.host.split('.').first + '.' + data_country_code
    url.to_s
  end

  def data_root_link
    URI.join(data_link, "/").to_s
  end

  def data_name
    self.data['Name']
  end

  def data_lots_count
    if self.data['lots']['lot'].kind_of?(Array)
      self.data['lots']['lot'].size
    else
      1
    end
  end

  def data_1st_lot_info
    self.data_lot_info
  end

  def data_lot_info(number = 0)
    if data_lots_count > 1
      self.data['lots']['lot'][number]
    elsif number == 0
      self.data['lots']['lot']
    else
      nil
    end
  end

  def data_customer
    data_1st_lot_info['customer']
  end

  def data_customer_name
    data_customer['Name']
  end

  def data_currency
    data_1st_lot_info['Currency']
  end

  def data_procedure_short_name
    self.data['Id'].split('-').last
  end

  def data_procedure_number
    self.data['Id'].split('-').first
  end

  def data_procedure_full_name
    case data_procedure_short_name
    when "ЗКП"
      "Запрос коммерческих предложений на закупку"
    when "ЗК"
      "Запрос котировок на закупку"
    when "А"
      "Аукцион на закупку"
    when "К"
      "Конкурс на закупку"
    else
      "Код процедуры #{data_procedure_short_name} на закупку"
    end
  end

  def data_country_code
    case data_currency
    when "RUB"
      'ru'
    when "KZT"
      'kz'
    else
      'ru'
    end
  end

  def data_time_start
    Time.parse(self.data['PurchaseStart'])
  end

  def time_zone_start
    time_zone(data_time_start)
  end

  def data_time_finish
    Time.parse(self.data['PurchaseFinishDate'])
  end

  def time_zone_finish
    time_zone(data_time_finish)
  end

  def time_results_till
    8.business_days.after(data_time_finish)
  end

  def time_zone_results_till
    time_zone time_results_till
  end

  def data_sum_of_lots_money
    sum = 0
    i = 0
    while i < data_lots_count
      sum += data_lot_info(i)['goods']['Price'].to_f if data_lot_info(i)['goods']['Price'] != nil
      i += 1
    end
    sum
  end

  def self.find_by_data_id(string)
    Tender.where("data -> 'Id' ? :data_id", data_id: string)
  end

  def self.find_by_number(number)
    Tender.where("data ->> 'Id' ~* ?", '^' + number.to_s + '-\S')
  end




  private

    def time_zone(time)
      case self.data_country_code
      when 'kz'
        ActiveSupport::TimeZone['Astana'].at(time).strftime("%e.%m.%Y %H:%M (Astana)")
      else
        ActiveSupport::TimeZone['Moscow'].at(time).strftime("%e.%m.%Y %H:%M (MSK)")
      end
    end

end
