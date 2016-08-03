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
    URI.join(URI.parse(self.data['Link']), "/").to_s
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
    if data_lots_count > 1
      self.data['lots']['lot'][0]
    else
      self.data['lots']['lot']
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

  def self.find_by_data_id(string)
    Tender.where("data -> 'Id' ? :data_id", data_id: string)
  end

  def self.find_by_number(number)
    Tender.where("data ->> 'Id' LIKE '%:numb%'", numb: number.to_i)
  end
end
