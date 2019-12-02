class NotificationsController < ApplicationController
  before_action :authorize
  def index; end

  def show
    @notifications = Notification.with_rut(params[:id]).unread
  end

  def create
    redirect_to notifications_path && return if params[:rut].blank?
    redirect_to notification_path(params[:rut].delete('.,'))
  end

  def update
    notification = Notification.find(params[:id])
    notification.update_column(:read, true)
    redirect_to notification_path(notification.rut)
  end

  def rut; end
end
