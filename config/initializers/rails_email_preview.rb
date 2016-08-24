require 'rails_email_preview'

#= REP hooks and config
RailsEmailPreview.setup do |config|


  # config.style.merge!(
  #   btn_active_class_modifier: 'active',
  #   btn_danger_class:          'btn btn-danger',
  #   btn_default_class:         'btn btn-default',
  #   btn_group_class:           'btn-group btn-group-sm',
  #   btn_primary_class:         'btn btn-primary',
  #   form_control_class:        'form-control',
  #   list_group_class:          'list-group',
  #   list_group_item_class:     'list-group-item',
  #   row_class:                 'row',
  #   )
  #
  #  # hook before rendering preview:
  #  config.before_render do |message, preview_class_name, mailer_action|
  #    # apply premailer-rails:
  #    Premailer::Rails::Hook.delivering_email(message)
  #    # or actionmailer-inline-css:
  #    ActionMailer::InlineCssHook.delivering_email(message)
  #  end
  #
  #  # do not show Send Email button
   config.enable_send_email = false
  #
  #  # You can specify a controller for RailsEmailPreview::ApplicationController to inherit from:
  #  config.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
end

#= REP + Comfortable Mexican Sofa integration
#
# # enable comfortable_mexican_sofa integration:
# require 'rails_email_preview/integrations/comfortable_mexica_sofa'

Rails.application.config.to_prepare do
  # Render REP inside a custom layout (set to 'application' to use app layout, default is REP's own layout)
  # This will also make application routes accessible from within REP:
  # RailsEmailPreview.layout = 'admin'

  # Set UI locale to something other than :en
  RailsEmailPreview.locale = :ru

  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = RailsEmailPreview.find_preview_classes('app/mailer_previews')

  RailsEmailPreview::ApplicationController.module_eval do
    before_action :set_variables

    private
    def set_variables
      @tender_id ||= params[:tender_id]
      # puts "TENDER ID FROM CALLBACK: #{@tender_id}"
      # puts "PARAMS FROM CALLBACK: #{params[:tender_id]}"
      if @tender_id.include?('-')
        @tender = Tender.find_by_data_id(@tender_id).first
      else
        @tender = Tender.find_by_number(@tender_id).first
      end
      if @contact_id == nil
        @contact_id =  '10898404' #если что-то пошло не так, то писмьо отправиться тестовому контакту
      end


      @client = Amorail::Contact.find(@contact_id) || Amorail::Lead.find(@contact_id).contacts.first
      @manager = Amorail.properties.data['users'].select{|user| user['id'].to_i == @client.responsible_user_id}.first

      @all_lots = @tender.data_lots_count
      puts "
        -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        |    REP initializer CALLBACK
        |    tender = #{@tender.data_id}
        |    tender.data_lots_count = #{@all_lots}
        |    manager = #{@manager}
        |    FIND CLIENT #{@client.name} from CONTACT ID: #{@contact_id}
        -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
            "

    end
  end
end
