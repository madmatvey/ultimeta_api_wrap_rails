class Import < ActiveRecord::Base
  require 'open-uri'


  def tenders
    self.data['source']['tender'] if self.data != nil
  end

  def tenders_digest
    self.digest ||= Digest::SHA1.hexdigest(self.tenders.join)
  end


  def load_data_from_api(time_from = nil,time_to = nil)

    self.time_from = time_from || Time.parse("2013-01-01T00:00").to_i
    self.time_to   = time_to   || Time.now.to_i

    # if import.time_from + 300 > Time.now.to_i
    #   results = "OOPS! There are no 5 minutes from last import being.\n Now is #{Time.now} and last import was #{Time.at(import.time_from)} \n Wait for a #{Time.now.to_i - import.time_from - 300} seconds"
    # else
    apiurl = "http://24tender.ru/api/trades/search?modifiedFrom="+Time.at(self.time_from).xmlschema+"&modifiedTo="+Time.at(self.time_to + 10.hours.to_i).xmlschema+"&page=1"
    puts "загружаю страницу 1"
    doc = Nokogiri.XML(open(apiurl))
    doc.encoding = 'utf-8'
    data = Hash.from_xml(doc.to_s)
    xml_pages_count = data["source"]["PagesCount"].to_i


    if xml_pages_count > 1
      page = 2
      (xml_pages_count-1).times do
        puts "загружаю страницу #{page}"
        apiurl = "http://24tender.ru/api/trades/search?modifiedFrom="+Time.at(self.time_from).xmlschema+"&modifiedTo="+Time.at(self.time_to).xmlschema+"&page="+page.to_s
        doc = Nokogiri.XML(open(apiurl))
        doc.encoding = 'utf-8'
        hash = Hash.from_xml(doc.to_s)
        data['source']['tender']+= hash['source']['tender']
        page += 1
      end
    end


    self.data = data

    self.digest = self.tenders_digest
  end

  def save_all_tenders!
    if self.data != nil
      self.tenders.each do |tender|
        if t = Tender.find_by_data_id(tender['Id']).first
          puts "Нашел тендер #{t.data_id}"
          digest = Digest::SHA1.hexdigest(tender.to_s)
          if t.digest == digest
            puts "Сравнил хеши – одинаковые [ПРОПУСКАЮ] (#{t.digest})==(#{digest})"

          else
            puts "Сравнил хеши – НЕ одинаковые: [ОБНОВЛЯЮ ИНФО по процедуре и записываю модификации]"
            t.modifications.create({ data: HashDiff.diff(tender,t.data) })
            t.data = tender
            t.digest = digest
            t.save
          end
        else
          t = Tender.new
          t.data = tender
          t.digest = Digest::SHA1.hexdigest(tender.to_s)
          t.save
          puts "Сохраняю новый тендер #{tender['Id']} (#{t.digest})"
        end
      end
    end
  end

  def find_changes_tenders
    if self.data != nil
      result = []
      self.tenders.each do |tender|
        t = Tender.find_by_data_id(tender['Id']).first
        puts "Нашел тендер #{t.data_id}"
        digest = Digest::SHA1.hexdigest(tender.to_s)
        if t.digest == digest
          puts "Сравнил хеши – одинаковые == ИЗМЕНЕНИЙ НЕТ! (#{t.digest})==(#{digest})"
          # result = nil
        else
          puts "Сравнил хеши – НЕ одинаковые: записываю результат в modifications "
          t.modifications.create({ data: HashDiff.diff(tender,t.data) })
          t.data = tender
          t.save
          result << tender
        end
      end
    end
    result
  end

end
