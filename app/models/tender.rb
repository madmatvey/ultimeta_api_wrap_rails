class Tender < ActiveRecord::Base
  has_many :modifications

  def data_id
    self.data['Id']
  end

  def data_link
    self.data['Link']
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

  def data_customer_name
    if data_lots_count > 1
      self.data['lots']['lot'][0]['customer']['Name']
    else
      self.data['lots']['lot']['customer']['Name']
    end
  end

  def self.find_by_data_id(string)
    Tender.where("data -> 'Id' ? :data_id", data_id: string)
  end
end
