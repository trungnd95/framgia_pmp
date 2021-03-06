class Admin::SprintsController < ApplicationController
  include SprintHelper
  load_and_authorize_resource
  load_and_authorize_resource :project, except: :show
  load_and_authorize_resource :sprint, except: :show
  before_action :load_assignee, except: :destroy

  def create
    if @sprint.save
      flash[:success] = flash_message "created"
      redirect_to project_sprint_path(@project, @sprint)
    else
      flash.now[:failed] = flash_message "not_created"
      render :new
    end
  end

  def update
    if @sprint.update_attributes sprint_params
      @sprint.update_master_sprint
      flash[:success] = flash_message "updated"
      redirect_to project_sprint_path(@project, @sprint)
    else
      flash.now[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @sprint.destroy
      flash[:success] = flash_message "deleted"
      redirect_to admin_project_path(@project)
    else
      flash.now[:failed] = flash_message "not_updated"
      redirect_to admin_project_sprint_path(@project, @sprint)
    end
  end

  private
  def load_assignee
    @assignees = @project.assignees.not_assign_sprint
  end

  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end
end
