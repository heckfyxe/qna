class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { alert: exception.message }, code: :forbidden }
      format.js { render inline: "alert('#{exception.message}')", code: :forbidden }
    end
  end
end
