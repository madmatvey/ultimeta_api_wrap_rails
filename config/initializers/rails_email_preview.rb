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
end
