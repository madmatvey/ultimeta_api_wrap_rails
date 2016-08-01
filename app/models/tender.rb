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

  def self.find_by_data_id(string)
    Tender.where("data -> 'Id' ? :data_id", data_id: string)
  end
end
