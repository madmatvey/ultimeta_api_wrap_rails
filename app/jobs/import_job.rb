class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    import = Import.new
    import.load_data_from_api
    import.save!
    import.reload
    import.find_changes_tenders
    import.save_all_tenders!
  end
end
